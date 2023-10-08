from bs4 import BeautifulSoup
import re


def extract_links(contents):
    """HTMLレスポンスの文字列から、必要なContry-Yearのリンクを取得し返す関数

    Args:
        contents (String): HTMLレスポンスの文字列
    """
    soup = BeautifulSoup(contents, 'lxml')
    # soup -> div str -> ul list
    ul = soup.find(
        class_="menu-coe-country-programs-menu-container").select("ul.sub-menu")
    # ul [] -> a [[]]
    a = list(map(lambda ul: ul.select("a"), ul))
    # a [[]] -> a [] -> href []
    links = list(map(lambda a: a.get("href"), sum(a, [])))
    return links


def extract_additional_link(contents):
    soup = BeautifulSoup(contents, 'lxml')
    # coeへのリンクが存在するかどうかのチェック
    a = soup.select(
        'div.wprt-container div')[0].find(href=re.compile("https://cupofexcellence.org"))
    if a:
        url = a.get('href')
        return url
    else:
        return None


def blank_fixer(text):
    """あらゆるカラム名に対する空白処理.2つ以上の空白を1つに,先頭末尾の空白の削除

    Args:
        text (str): str型

    Returns:
        str: 空白
    """
    return re.sub('\s{2,}', ' ', text).strip()


def scrapingPage(contents, result):
    soup = BeautifulSoup(contents, 'lxml')
    # サイト上のデータ
    result['program'] = soup.find('h1').get_text().strip()
    result['description'] = [{'p': [x.text for x in block.find_all('p')],
                              'li':[x.text for x in block.find_all('li')]}
                             for block in soup.select('h1 ~ div > div.mk-text-block')]
    result['remarks'] = [x.text for x in soup.select(
        'div.vc_tta-container ~ div p')]

    # 各テーブル情報の抽出
    panels = soup.find_all('div', attrs={'class': 'vc_tta-panel'})  # テーブルリスト
    result = extractInfoFromPanels(panels, result)
    return result


def extractInfoFromPanels(panels, result):
    """from panels html to dict

    Args:
        panels (_type_): _description_
        result (_type_): _description_

    Returns:
        _type_: _description_
    """
    # 正規表現の準備
    last_line_checker = re.compile('total|stat')
    column_fixer = re.compile('[^a-zA-Z0-9]')
    for panel in panels:
        # panelのタイトル
        panel_title = panel.find(
            'span', attrs={'class': 'vc_tta-title-text'}).get_text().strip()
        panel_title = column_fixer.sub('_', blank_fixer(panel_title))
        # sponsor
        if 'sponsor' in panel_title.lower():
            if panel.img.get('src'):
                result[panel_title] = {'url': panel.img.get('src')}
            elif panel.ul:
                result[panel_title] = {
                    'li': [li.text.strip() for li in panel.find_all('li')]}
        # panelがtableのケース
        elif panel.table:
            # 各パネルの箱と初期値
            result[panel_title] = []
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
                for tr in table.tbody.find_all('tr'):
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
                    if tr.find('td').get('data-mtr-content') == tr.find('td').text:
                        continue
                    # 最終行に特定の条件があればスキップする処理
                    elif last_line_checker.match(tr.find('td').text.lower()):
                        continue
                    # 各セルごとの処理
                    for td in tr.find_all('td'):
                        # カラム名取得
                        column = column_fixer.sub(
                            '_', blank_fixer(td.get('data-mtr-content')))
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
                            # 既に格納したことのあるURLかのチェック
                            individual_url = td.a.get('href')
                            if individual_url not in result['individual_unique_links']:
                                row['url'] = td.a.get('href')
                                # 未知のURLとして保存
                                result['individual_unique_links'].add(
                                    individual_url)
                                # tableごとにURLが存在したかをチェック
                                result['individual_flag'].add(
                                    panel_title)
                    # write row
                    result[panel_title].append(row)
            # theadがあるパターン
            elif table.thead:
                columns = list(map(lambda x: column_fixer.sub(
                    '_', blank_fixer(x.text)), table.thead.find_all('th')))
                # 審査員テーブルが存在する場合
                if 'jury' in panel_title.lower():
                    bool_jury = True
                # １行ごとテーブル内容の処理
                for tr in table.tbody.find_all('tr'):
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
                    if last_line_checker.match(tr.find('td').text.lower()):
                        continue
                    # 各セルごとの処理
                    for column, td in zip(columns, tr.find_all('td')):
                        row[column] = td.text.strip()
                        # urlも存在する場合
                        if td.a:
                            # 既に格納したことのあるURLかのチェック
                            individual_url = td.a.get('href')
                            if individual_url not in result['individual_unique_links']:
                                row['url'] = td.a.get('href')
                                # 未知のURLとして保存
                                result['individual_unique_links'].add(
                                    individual_url)
                                # tableごとにURLが存在したかをチェック
                                result['individual_flag'].add(
                                    panel_title)
                    # write row
                    result[panel_title].append(row)

            # 上記のどちらでもないパターン(2022BrazilAuction)
            else:
                # １行ごとテーブル内容の処理
                for tr in table.tbody.find_all('tr'):
                    # カラム名が保存されている1行目の処理
                    if tr.find('td').text.lower() == 'rank':
                        columns = list(map(lambda x: column_fixer.sub(
                            '_', blank_fixer(x.text)), tr.find_all('td')))
                        continue
                    # １行ごとの箱
                    row = {}
                    # 最終行の処理
                    if last_line_checker.match(tr.find('td').text.lower()):
                        continue
                    # 各セルごとの処理
                    for column, td in zip(columns, tr.find_all('td')):
                        row[column] = td.text.strip()
                        # urlも存在する場合
                        if td.a:
                            # 既に格納したことのあるURLかのチェック
                            individual_url = td.a.get('href')
                            if individual_url not in result['individual_unique_links']:
                                row['url'] = td.a.get('href')
                                # 未知のURLとして保存
                                result['individual_unique_links'].add(
                                    individual_url)
                                # tableごとにURLが存在したかをチェック
                                result['individual_flag'].add(
                                    panel_title)
                    # write row
                    result[panel_title].append(row)
    return result


def extractInfoFromIndividuals(contents, url):
    individual_result = {}
    soup = BeautifulSoup(contents, 'lxml')
    if ('cupofexcellence.org/directory' in url) or ('allianceforcoffeeexcellence.org/farm-directory' in url):
        # image-links
        images = list(map(lambda x: x.img.get('srcset'),
                      soup.select('ul.other-images a')))
        images_result = []
        for l in [chooseBestLink(x) for x in images]:
            images_result.append(l)
        individual_result['images'] = images_result

        # description
        description = soup.select('#listing-description')
        individual_result['description'] = {}
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
        individual_result['description'] = {"p": [p.text.strip() for p in soup.find(
            "h5", text="Description").parent.parent.parent.parent.find_all("p")]}

        # Gallery
        individual_result['gallery'] = [a.get("href") for a in soup.find(
            "h5", text="Gallery").parent.parent.parent.parent.find_all("a")]

        # Farm Information
        individual_result['farm_information'] = {}
        for li in soup.find("h5", text="Farm Information").parent.parent.parent.parent.find_all("li"):
            individual_result['farm_information'][li.find(
                class_="item-attr").text.strip()] = li.find(class_="item-property").text.strip()

        # Location
        try:
            individual_result['location'] = soup.find(
                "h5", text="Location").parent.parent.parent.parent.find("p").text
        except AttributeError:
            individual_result['location'] = None

        # Score
        individual_result['score'] = {}
        for li in soup.find("h5", text="Score").parent.parent.parent.parent.find_all("li"):
            individual_result['score'][li.find(
                class_="item-attr").text.strip()] = li.find(class_="item-property").text.strip()

        # Lot Information
        individual_result['lot_information'] = {}
        for li in soup.find("h5", text="Lot Information").parent.parent.parent.parent.find_all("li"):
            individual_result['lot_information'][li.find(
                class_="item-attr").text.strip()] = li.find(class_="item-property").text.strip()

        # Similar Farm
        try:
            individual_result['similar_farm'] = [
                a.get("href") for a in soup.find(class_="similar-listings").find_all("a")]
        except AttributeError:
            individual_result['similar_farm'] = None

        return individual_result


def chooseBestLink(a):
    d = re.compile(r'\s\d+w')
    s = re.compile(r'\s|w')
    linklist = a.split(',')
    resolutions = [int(s.sub('', d.search(l).group()))
                   for l in linklist]
    maxindex = resolutions.index(max(resolutions))
    links = d.sub('', linklist[maxindex].strip())
    if len(links) == 0:
        return None
    else:
        return links
