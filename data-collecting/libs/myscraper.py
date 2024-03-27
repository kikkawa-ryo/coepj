from bs4 import BeautifulSoup
from itertools import zip_longest
import re


def extract_links(parse_target):
    """HTMLレスポンスの文字列から、必要なContry-Yearのリンクを取得し返す関数
    外部から呼び出される用途

    Args:
        parse_target (String): HTMLレスポンスの文字列
    """
    soup = BeautifulSoup(parse_target, 'lxml')
    # 1.soup -> div str -> ul list
    ul = soup.find(
        class_="menu-coe-country-programs-menu-container").select("ul.sub-menu")
    # 2.ul [] -> a [[]]
    a = list(map(lambda ul: ul.select("a"), ul))
    # 3.a [[]] -> a [] -> href []
    links = list(map(lambda a: a.get("href"), sum(a, [])))
    return links


def check_and_get_additional_url(parse_target):
    soup = BeautifulSoup(parse_target, 'lxml')
    # coeへのリンクが存在するかどうかのチェック
    a = soup.select('div.wprt-container div')[0].find(href=re.compile(
        'https://cupofexcellence.org(?!.*global-coffee-centers)'))
    if a:
        url = a.get('href')
        return url
    else:
        return None

def column_fixer(text):
    text = re.sub('[^a-zA-Z0-9]', '_', text.strip()).strip()
    text = re.sub('\s{2,}', ' ', text.strip()).strip()
    text = re.sub('_{2,}', '_', text.strip()).strip()
    text = text.casefold().title()
    return text

def scrapingPage(parse_target, content_container, page_info_container, target_url):
    soup = BeautifulSoup(parse_target, 'lxml')
    # 大会プログラムを説明するようなデータ
    page_info_container['program'] = soup.find('h1').get_text().strip()
    page_info_container['description'] = [{'p': [x.text for x in block.find_all('p')],
                                           'li': [x.text for x in block.find_all('li')]} for block in soup.select('h1 ~ div > div.mk-text-block')]
    page_info_container['remarks'] = [
        x.text for x in soup.select('div.vc_tta-container ~ div p')]

    # 各テーブル情報の抽出
    panels = soup.find_all('div', attrs={'class': 'vc_tta-panel'})  # テーブルリスト
    content_container, page_info_container = extractInfoFromPanels(
        panels, content_container, page_info_container, target_url)
    return content_container, page_info_container

def extractInfoFromPanels(panels, content_container, page_info_container, target_url):
    def is_validated_url(url):
        return not bool(re.compile(r'auction.allianceforcoffeeexcellence.org|cdn-cgi').search(url))
    def is_skip_row(tr, columns):
        # カラム情報の行かどうか
        bool1 = (tr.find('td') != None) and (column_fixer(tr.find('td').text) == columns[0])
        bool2 = (tr.find('th') != None) and (column_fixer(tr.find('th').text) == columns[0])
        bool3 = (tr.find('td') != None) and (tr.find('td').text == columns[0])
        bool4 = (tr.find('th') != None) and (tr.find('th').text == columns[0])
        # 集計行の場合
        last_line_checker = re.compile('total|stat')
        bool5 = any(map(lambda s: bool(last_line_checker.search(s.text.lower())), tr.find_all('td')))
        # 空のセルが複数存在する場合
        bool6 = list(map(lambda s: s.text.lower(), tr.find_all('td'))).count('') >= 2
        return bool1 or bool2 or bool3 or bool4 or bool5 or bool6
    # panelごとの処理
    for panel in panels:
        # panelのタイトル
        panel_title = panel.find(
            'span', attrs={'class': 'vc_tta-title-text'}).get_text().strip()
        panel_title = column_fixer(panel_title)
        # |||sponsor|||
        if 'sponsor' in panel_title.lower():
            if (panel.img is None) and (panel.ul is None):
                content_container[panel_title] = None
            if panel.img is not None:
                content_container[panel_title] = {
                    'img': {'url': [img.get('src') for img in panel.find_all('img')]}}
            if panel.ul is not None:
                content_container[panel_title] = {'li': [{'text': li.text.strip(), 'url': li.a.get('href') if li.a is not None else None}
                                                         for li in panel.find_all('li')]}
        # |||competition, auction, commissions, jury|||
        elif panel.table:
            # juryのための準備
            is_jury = "jury" in panel_title.lower()
            group = None
            # 各パネルの箱と初期値
            content_container[panel_title] = []
            # target_tableの選定
            if is_jury and "brazil-naturals-2015-january" in target_url.lower():
                target_table = panel.find("table").table
            else:
                target_table = panel.table
            """ Column処理 """
            # tableのHTMLタイプをチェック後、column情報の取得
            # 1.theadが存在する場合
            if target_table.thead:
                columns = list(map(lambda x: column_fixer(x.text), target_table.thead.tr.find_all('th')))
            # 2.tdにcolumn情報が存在する場合
            elif target_table.find('td', attrs={'class': 'mtr-td-tag'}):
                columns = list(map(lambda x: column_fixer(x.get('data-mtr-content')), target_table.tr.find_all('td')))
            # 3.カラムが存在しないhonduras-2018-auctionの処理
            elif "honduras-2018" in target_url and "auction" in panel_title.lower():
                columns = ["Rank", "Farm", "Lot_Size", "High_Bid", "Total_Value", "High_Bidder_S_"]
            # 4.何も情報がない場合、1行目の要素を仮のカラムとする
            else:
                columns = list(map(lambda x: column_fixer(x.text), target_table.tr.find_all('td')))
                if len(columns) == 0:
                    columns = list(map(lambda x: column_fixer(x.text), target_table.tr.find_all('th')))
            # 5.irregular
            if "Selection" in columns or "Week" in columns:
                print()
                pass
            """ contentsの処理 """
            if panel.table.tbody:
                target_contents = target_table.tbody
            else:
                target_contents = target_table.thead
            # 行ごとの処理
            for tr in target_contents.find_all('tr'):
                # jury属性を持っている場合、属性を更新しスキップする
                if is_jury and (tr.th or len(tr.find_all('td'))==1):
                    group = tr.text
                    continue
                # スキップ対象のrowかどうかチェック
                if is_skip_row(tr, columns):
                    continue
                # １行ごとの箱の初期化
                # rowspan設定された行の場合は前の行の箱に保存
                if "have_rowspan" in locals() and have_rowspan:
                    # 前の行で保存した値＋今回の行の値に更新
                    content_container[panel_title][-1][target_column] = content_container[panel_title][-1][target_column] + "+" + tr.td.text.strip()
                    num_of_row_remains += -1
                    if num_of_row_remains == 0:
                        have_rowspan = False
                    continue
                else:
                    row = {}
                # juryのgroupが設定されている場合
                if is_jury and group:
                    row['group'] = group
                # targetとなるデータのリスト
                if tr.td:
                    td_list = tr.find_all('td')
                else:
                    td_list = tr.find_all('th')
                # colspanをもつ場合、tdのリストを修正
                if any(map(lambda td: td.get('colspan') is not None, td_list)):
                    row["span"] = "colspan"
                    target_td_list = []
                    for td in td_list:
                        # colspanをもつtdを保存
                        if td.get('colspan') is not None:
                            target_td_list.append(td)
                    for target_td in target_td_list:
                        num_of_col_remains = int(target_td.get('colspan')) - 1
                        while num_of_col_remains > 0:
                            td_list.insert(td_list.index(target_td), target_td)
                            num_of_col_remains += -1
                # rowspanの有無チェック
                have_rowspan = any(map(lambda td: td.get('rowspan') is not None, tr.find_all('td')))
                # 各セルごとの処理
                for column, td in zip(columns, td_list):
                    # rowspan設定が存在する場合、次行で処理するためのフラグ作成
                    if have_rowspan and td.get('rowspan') is None:
                        row["span"] = "rowspan"
                        target_column = column
                        num_of_row_remains = int(td.parent.select_one("td[rowspan]").get('rowspan')) - 1
                        # rowspan=1対策
                        if num_of_row_remains == 0:
                            have_rowspan = False
                    # 値の保存
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
    return content_container, page_info_container

def extractInfoFromIndividuals(contents, url):
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
    individual_result = {}
    soup = BeautifulSoup(contents, 'lxml')
    if ('cupofexcellence.org/directory' in url) or ('allianceforcoffeeexcellence.org/farm-directory' in url) or ('allianceforcoffeeexcellence.org/directory' in url):
        # image-links
        images_urls_candidate_list = list(map(
            lambda x: x.img.get('srcset') if x.img.get('srcset') is not None else x.img.get('src'), soup.select('ul.other-images a')))
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
            individual_result['description']['p'] = [
                p.text.strip() for p in description[0].find_all('p')]
            individual_result['description']['tr'] = [
                tr.text.strip() for tr in description[0].find_all('tr')]
            individual_result['description']['li'] = [
                li.text.strip() for li in description[0].find_all('li')]

        # detail
        details = soup.select('#listing-details tr')
        individual_table = {}
        for tr in details:
            individual_table[column_fixer(tr.th.text)] = tr.td.text
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
