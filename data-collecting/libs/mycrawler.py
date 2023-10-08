import requests
import time

from libs import myscraper


def crawl_start_link(url):
    response = requests.get(url, headers={
                            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36'})
    url_list = myscraper.extract_links(response.content)
    return url_list


def my_requsest_get(url):
    time.sleep(2)
    response = requests.get(url, headers={
                            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36'})
    return response.content


class Crawler:
    def __init__(self, base_url):
        self.base_url = base_url
        self.result = {"base_url": base_url,
                       "individual_flag": set(),
                       "individual_unique_links": set()}

    def crawl(self):
        # URLからコンテンツを取得
        contents = my_requsest_get(self.base_url)
        # 追加でクローリングするべきURLが存在するかの確認
        extract_additional_url = myscraper.extract_additional_link(contents)
        # 全体ページのクローリングとスクレイピング
        if extract_additional_url:
            self.result = myscraper.scrapingPage(contents, self.result)
            # 追加のGETリクエストを送信
            additional_contents = my_requsest_get(extract_additional_url)
            self.result = myscraper.scrapingPage(
                additional_contents, self.result)
        else:
            self.result = myscraper.scrapingPage(contents, self.result)
        # 個別ページのクローリングとスクレイピングをし、結果を更新
        flag = self.result['individual_flag']
        if len(flag) > 0:
            for table_name in list(flag):
                for i, row in enumerate(self.result[table_name]):
                    row.update({'individual_result': myscraper.extractInfoFromIndividuals(
                        my_requsest_get(row['url']), row['url'])})
                    self.result[table_name][i] = row
        # 最後にセットをリストに変換
        self.result["individual_flag"] = list(self.result["individual_flag"])
        self.result["individual_unique_links"] = list(
            self.result["individual_unique_links"])

    def export(self):
        return self.result
