import collections
import csv
import json
from dataclasses import dataclass
import requests
import time

from libs import myscraper


def get_result_urls(url):
    response = requests.get(url, headers={'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36'})
    url_list = myscraper.extract_links(response.content)
    return url_list


def get_response_by_my_requsest(url):
    time.sleep(2)
    response = requests.get(url, headers={'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36'})
    return response.content


class Crawler:
    def __init__(self, result_url):
        self.result_url = result_url
        self.content = {}
        self.page_info = {"visited_result_url_list": [result_url], "individual_flag": set(), "individual_unique_links": set()}
    # @dataclass
    # class Result:
    #     result_url: str
    #     content: dict
    #     page_info: dict
        
    def export_result_as_list(self):
        return [self.result_url, json.dumps(self.content, ensure_ascii=False), json.dumps(self.page_info, ensure_ascii=False)]
    
    def crawl(self):
        # URLからコンテンツを取得
        contents = get_response_by_my_requsest(self.result_url)
        # 追加でクローリングするべきURLが存在するかの確認
        additional_url = myscraper.check_and_get_additional_url(contents)
        # 追加URLが存在すれば、追加URLを含め全体ページのクローリングとスクレイピング
        if additional_url:
            # 追加URLをvisitedとして記録
            self.page_info['visited_result_url_list'].append(additional_url)
            # Responseの解析後、Result辞書を更新
            self.content, self.page_info = myscraper.scrapingPage(parse_target=contents, content_container=self.content, page_info_container=self.page_info)
            # 追加のGETリクエストを送信
            additional_contents = get_response_by_my_requsest(additional_url)
            self.content, self.page_info = myscraper.scrapingPage(parse_target=additional_contents, content_container=self.content, page_info_container=self.page_info)
        else:
            self.content, self.page_info = myscraper.scrapingPage(parse_target=contents, content_container=self.content, page_info_container=self.page_info)
        # 個別ページのクローリングとスクレイピングをし、結果を更新
        individual_column_list = self.page_info['individual_flag']
        if len(individual_column_list) > 0:
            for table_name in list(individual_column_list):
                for i, row in enumerate(self.content[table_name]):
                    row.update({'individual_result': myscraper.extractInfoFromIndividuals(
                        get_response_by_my_requsest(row['url']), row['url'])})
                    self.content[table_name][i] = row
        # 最後にセットをリストに変換
        self.page_info["individual_flag"] = list(self.page_info["individual_flag"])
        self.page_info["individual_unique_links"] = list(self.page_info["individual_unique_links"])
