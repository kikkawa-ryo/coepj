from bs4 import BeautifulSoup
from itertools import zip_longest
import re


def extract_links(parse_target):
    """HTMLレスポンスの文字列から、必要なContry-Yearのリンクを取得し返す関数

    Args:
        parse_target (String): HTMLレスポンスの文字列
    """
    soup = BeautifulSoup(parse_target, 'lxml')
    # 1.soup -> div str -> ul list
    ul = soup.find(class_="menu-coe-country-programs-menu-container").select("ul.sub-menu")
    # 2.ul [] -> a [[]]
    a = list(map(lambda ul: ul.select("a"), ul))
    # 3.a [[]] -> a [] -> href []
    links = list(map(lambda a: a.get("href"), sum(a, [])))
    return links

def check_and_get_additional_url(parse_target):
    soup = BeautifulSoup(parse_target, 'lxml')
    # coeへのリンクが存在するかどうかのチェック
    a = soup.select('div.wprt-container div')[0].find(href=re.compile('https://cupofexcellence.org(?!.*global-coffee-centers)'))
    if a:
        url = a.get('href')
        return url
    else:
        return None
    
def is_validated_url(url):
    return not bool(re.compile(r'auction.allianceforcoffeeexcellence.org|cdn-cgi').search(url))


def blank_fixer(text):
    """あらゆるカラム名に対する空白処理.2つ以上の空白を1つに,先頭末尾の空白の削除

    Args:
        text (str): str型

    Returns:
        str: 空白
    """
    return re.sub('\s{2,}', ' ', text).strip()

def chooseBestLink(a):
    d = re.compile(r'\s\d+w')
    s = re.compile(r'\s|w')
    linklist = a.split(',')
    if len(linklist) == 1:
        return a
    resolutions = [int(s.sub('', d.search(l).group()))
                   for l in linklist]
    maxindex = resolutions.index(max(resolutions))
    links = d.sub('', linklist[maxindex].strip())
    if len(links) == 0:
        return None
    else:
        return links


def scrapingPage(parse_target, content_container, page_info_container):
    soup = BeautifulSoup(parse_target, 'lxml')
    # 大会プログラムを説明するようなデータ
    page_info_container['program'] = soup.find('h1').get_text().strip()
    page_info_container['description'] = [{'p': [x.text for x in block.find_all('p')],
                                        'li': [x.text for x in block.find_all('li')]} for block in soup.select('h1 ~ div > div.mk-text-block')]
    page_info_container['remarks'] = [x.text for x in soup.select('div.vc_tta-container ~ div p')]

    # 各テーブル情報の抽出
    panels = soup.find_all('div', attrs={'class': 'vc_tta-panel'})  # テーブルリスト
    content_container, page_info_container = extractInfoFromPanels(panels, content_container, page_info_container)
    return content_container, page_info_container


def extractInfoFromPanels(panels, content_container, page_info_container):
    """from panels html to dict

    Args:
        panels (_type_): _description_
        content_container (_type_): _description_
        page_info_container (_type_): _description_

    Returns:
        _type_: _description_
    """
    # 正規表現の準備
    last_line_checker = re.compile('total|stat')
    column_fixer = re.compile('[^a-zA-Z0-9]')
    for panel in panels:
        # panelのタイトル
        panel_title = panel.find('span', attrs={'class': 'vc_tta-title-text'}).get_text().strip()
        panel_title = column_fixer.sub('_', blank_fixer(panel_title))
        # sponsor
        if 'sponsor' in panel_title.lower():
            if (panel.img is None) and (panel.ul is None):
                content_container[panel_title] = None
            if panel.img is not None:
                content_container[panel_title] = {'img':{'url': [img.get('src') for img in panel.find_all('img')]}}
            if panel.ul is not None:
                content_container[panel_title] = {'li': [{'text': li.text.strip()
                                                          , 'url': li.a.get('href') if li.a is not None else None} 
                                                         for li in panel.find_all('li')]}
                                                         
        # panelがtableのケース
        elif panel.table:
            # 各パネルの箱と初期値
            content_container[panel_title] = []
            # 審査員テーブルがあるかどうかのbool, デフォルトはナシ
            group = None  # juryの属性初期値
            bool_jury = False
            # 複数ある場合最初のもので十分
            table = panel.table
            # tdにheader情報が存在する場合
            if table.find('td', attrs={'class': 'mtr-td-tag'}):
                # 審査員テーブルが存在する場合
                if 'jury' in panel_title.lower():
                    bool_jury = True
                # １行ごとテーブル内容の処理
                if table.tbody:
                    contents = table.tbody
                else:
                    contents = table.thead
                for tr in contents.find_all('tr'):
                    # １行ごとの箱
                    row = {}
                    # jury処理
                    if bool_jury:
                        # jury属性であった場合、属性を更新しスキップする
                        if tr.th:
                            group = tr.th.text
                            continue
                        if group:
                            row['group'] = group
                    # 1行目がheader情報の行であればスキップする処理
                    if tr.find('th'):
                        if tr.find('th').get('data-mtr-content') == tr.find('th').text:
                            continue
                    elif tr.find('td'):
                        if tr.find('td').get('data-mtr-content') == tr.find('td').text:
                            continue
                    # 最終行に特定の条件があればスキップする処理
                    if any(map(lambda s: bool(last_line_checker.search(s.text.lower())), tr.find_all('td'))) or list(map(lambda s: s.text.lower(), tr.find_all('td'))).count('') >= 2:
                        continue
                    # 各セルごとの処理
                    for td in tr.find_all('td'):
                        # カラム名取得
                        column = column_fixer.sub('_', blank_fixer(td.get('data-mtr-content')))
                        # divとして値が設定されている場合
                        if td.get('data-sheets-value'):
                            # textとdivの比較し、同じ場合
                            if td.get('data-sheets-value').strip() == td.text.strip():
                                row[column] = td.text.strip()
                            else:
                                row[column] = {'text': td.text.strip(),
                                               'value': td.get('data-sheets-value').strip()}
                        else:
                            row[column] = td.text.strip()
                        # URLが存在する場合
                        if td.a:
                            individual_url = td.a.get('href')
                            # 妥当なURLかどうかの確認
                            if is_validated_url(individual_url):
                                row['url'] = individual_url
                                # tableごとにURLが存在したかをチェック
                                page_info_container['individual_flag'].add(panel_title)
                    # write row
                    content_container[panel_title].append(row)
            # theadがあるパターン
            elif table.thead:
                columns = list(map(lambda x: column_fixer.sub('_', blank_fixer(x.text)), table.thead.find('tr').find_all('th')))
                # 審査員テーブルが存在する場合
                if 'jury' in panel_title.lower():
                    bool_jury = True
                # １行ごとテーブル内容の処理
                if table.tbody:
                    contents = table.tbody
                else:
                    contents = table.thead
                for tr in contents.find_all('tr'):
                    # １行ごとの箱
                    row = {}
                    # jury処理
                    if bool_jury:
                        # jury属性であった場合、属性を更新しスキップする
                        if tr.th:
                            group = tr.th.text.strip()
                            continue
                        # 既に属性が保存されている場合、属性を格納する
                        if group:
                            row['group'] = group
                    # 最終行の処理
                    if any(map(lambda s: bool(last_line_checker.search(s.text.lower())), tr.find_all('td'))) or list(map(lambda s: s.text.lower(), tr.find_all('td'))).count('') >= 2:
                        continue
                    # 各セルごとの処理
                    for column, td in zip(columns, tr.find_all('td')):
                        row[column] = td.text.strip()
                        # urlも存在する場合
                        if td.a:
                            individual_url = td.a.get('href')
                            # 妥当なURLかどうかの確認
                            if is_validated_url(individual_url):
                                row['url'] = individual_url
                                # tableごとにURLが存在したかをチェック
                                page_info_container['individual_flag'].add(panel_title)
                    # write row
                    content_container[panel_title].append(row)

            # 上記のどちらでもないパターン(Brazil2022, Mexico2018)
            else:
                count=0
                # 審査員テーブルが存在する場合
                if 'jury' in panel_title.lower():
                    bool_jury = True
                # １行ごとテーブル内容の処理
                for tr in table.tbody.find_all('tr'):
                    # カラム名が保存されているはずの1行目の処理
                    if count == 0:
                        columns = list(map(lambda x: column_fixer.sub('_', blank_fixer(x.text)), tr.find_all('td')))
                        count+=1
                        continue
                    # span設定された行でない場合、１行ごとの箱を初期化
                    if "bool_rowspan" in locals():
                        content_container[panel_title][-1][target_column] = content_container[panel_title][-1][target_column] + "+" + tr.td.text.strip()
                        num_of_row_remains += -1
                        if num_of_row_remains == 0:
                            del bool_rowspan
                        continue
                    else:
                        row = {}
                    # jury処理
                    if bool_jury:
                        # jury属性であった場合、属性を更新しスキップする
                        if tr.th:
                            group = tr.th.text.strip()
                            continue
                        # 既に属性が保存されている場合、属性を格納する
                        if group:
                            row['group'] = group
                    # 最終行の処理
                    if any(map(lambda s: bool(last_line_checker.search(s.text.lower())), tr.find_all('td'))) or list(map(lambda s: s.text.lower(), tr.find_all('td'))).count('') >= 2:
                        continue
                    # 通常行
                    if not any(map(lambda td: (td.get('colspan') is not None) or (td.get('rowspan') is not None), tr.find_all('td'))):
                        # 各セルごとの処理
                        for column, td in zip(columns, tr.find_all('td')):
                            row[column] = td.text.strip()
                            # urlも存在する場合
                            if td.a:
                                individual_url = td.a.get('href')
                                # 妥当なURLかどうかの確認
                                if is_validated_url(individual_url):
                                    row['url'] = individual_url
                                    # tableごとにURLが存在したかをチェック
                                    page_info_container['individual_flag'].add(panel_title)
                    # span設定行
                    else:
                        have_colspan = any(map(lambda td: td.get('colspan') is not None, tr.find_all('td')))
                        have_rowspan = any(map(lambda td: td.get('rowspan') is not None, tr.find_all('td')))
                        # 各セルごとの処理
                        for column, td in zip(columns, tr.find_all('td')):
                            # イレギュラーセルの処理(colは存在すれば、rowは存在しなければイレギュラー)
                            # colspan設定が存在する場合、次セルで処理
                            if have_colspan and td.get('colspan') is not None:
                                target_value = td.text.strip()
                                bool_colspan = True
                                num_of_col_remains = int(td.get('colspan')) - 1
                                row[column] = td.text.strip()
                            # rowspan設定が存在する場合、次行で処理
                            elif have_rowspan and td.get('rowspan') is None:
                                target_column = column
                                bool_rowspan = True
                                num_of_row_remains = int(td.parent.select_one("td[rowspan]").get('rowspan')) - 1
                                row[column] = td.text.strip()
                            # 通常セルの処理
                            else:
                                # span設定されていた場合は該当セルの値を保存
                                if "bool_colspan" in locals():
                                    row[column] = target_value
                                    num_of_col_remains += -1
                                    if num_of_row_remains == 0:
                                        del bool_colspan
                                else:
                                    row[column] = td.text.strip()
                            # urlも存在する場合
                            if td.a:
                                individual_url = td.a.get('href')
                                # 妥当なURLかどうかの確認
                                if is_validated_url(individual_url):
                                    row['url'] = individual_url
                                    # tableごとにURLが存在したかをチェック
                                    page_info_container['individual_flag'].add(panel_title)    
                        # 初期化
                        del have_colspan
                        del have_rowspan
                    # write row
                    content_container[panel_title].append(row)
    return content_container, page_info_container


def extractInfoFromIndividuals(contents, url):
    individual_result = {}
    soup = BeautifulSoup(contents, 'lxml')
    if ('cupofexcellence.org/directory' in url) or ('allianceforcoffeeexcellence.org/farm-directory' in url) or ('allianceforcoffeeexcellence.org/directory' in url):
        # image-links
        images_urls_candidate_list = list(map(lambda x: x.img.get('srcset') if x.img.get('srcset') is not None else x.img.get('src'), soup.select('ul.other-images a')))
        images_result = []
        for l in [chooseBestLink(x) for x in images_urls_candidate_list]:
            images_result.append(l)
        individual_result['images'] = images_result

        # description
        description = soup.select('#listing-description')
        individual_result['description'] = {}
        if len(description) == 0:
            individual_result['description']['p'] = []
            individual_result['description']['tr'] = []
            individual_result['description']['li'] = []
        else:
            individual_result['description']['p'] = [p.text.strip()
                                                    for p in description[0].find_all('p')]
            individual_result['description']['tr'] = [tr.text.strip()
                                                    for tr in description[0].find_all('tr')]
            individual_result['description']['li'] = [li.text.strip()
                                                    for li in description[0].find_all('li')]

        # detail
        schema_fixer = re.compile('[^a-zA-Z0-9]')
        details = soup.select('#listing-details tr')
        individual_table = {}
        for tr in details:
            individual_table[schema_fixer.sub('_', tr.th.text)] = tr.td.text
        individual_result['detail'] = individual_table
        return individual_result

    elif 'farmdirectory.cupofexcellence.org/listing' in url:
        # Description
        individual_result['description'] = []
        try:
            individual_result['description'] = {"p": [p.text.strip() for p in soup.find(
                "h5", text="Description").parent.parent.parent.parent.find_all("p")]}
        except AttributeError:
            print("description", url)

        # Gallery
        individual_result['gallery'] = []
        try:
            individual_result['gallery'] = [a.get("href") for a in soup.find(
                "h5", text="Gallery").parent.parent.parent.parent.find_all("a")]
        except AttributeError:
            print("gallery", url)

        # Farm Information
        individual_result['farm_information'] = {}
        try:
            for li in soup.find("h5", text="Farm Information").parent.parent.parent.parent.find_all("li"):
                individual_result['farm_information'][li.find(
                    class_="item-attr").text.strip()] = li.find(class_="item-property").text.strip()
        except AttributeError:
            print("farm_information", url)
            
        # Location
        individual_result['location'] = []
        try:
            individual_result['location'] = soup.find(
                "h5", text="Location").parent.parent.parent.parent.find("p").text
        except AttributeError:
            print("location", url)

        # Score
        individual_result['score'] = {}
        try:
            for li in soup.find("h5", text="Score").parent.parent.parent.parent.find_all("li"):
                individual_result['score'][li.find(
                    class_="item-attr").text.strip()] = li.find(class_="item-property").text.strip()
        except AttributeError:
            print("score", url)
            
        # Lot Information
        individual_result['lot_information'] = {}
        try:
            for li in soup.find("h5", text="Lot Information").parent.parent.parent.parent.find_all("li"):
                individual_result['lot_information'][li.find(
                    class_="item-attr").text.strip()] = li.find(class_="item-property").text.strip()
        except AttributeError:
            print("lot_information", url)
            
        # Similar Farm
        try:
            individual_result['similar_farm'] = [
                a.get("href") for a in soup.find(class_="similar-listings").find_all("a")]
        except AttributeError:
            individual_result['similar_farm'] = []
            print("similar_farm", url)

        return individual_result
