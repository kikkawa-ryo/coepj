def main():
    import csv
    import re

    from libs import mycrawler
    from libs import mydatabase_connector
    from config import settings

    # get visited urls
    visited_urls = mydatabase_connector.get_visited_urls()
    
    # prepare start url and get target urls
    result_url = settings.RESULT_URL
    result_urls = mycrawler.get_result_urls(result_url)
    
    # make this time urls list
    never_visit_urls = list(set(result_urls)-set(visited_urls))
    # filered list
    target_urls = sorted(list(filter(lambda s: not bool(re.compile(r'2023').search(s)) , never_visit_urls)))

    # crawl target url
    for url in target_urls:
        print(url)

        # generate instance
        detail_crawler = mycrawler.Crawler(url)
        # crawl
        detail_crawler.crawl()

        # save data as csv file
        file_name = re.sub("https:\/\/(.+?)\/(.+?)\/", r"\2", url)
        
        with open('data-collecting/data/tmp.csv', 'w', encoding='utf-8', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(detail_crawler.export_result_as_list())

        # upload data from local to storage
        mydatabase_connector.upload_data_to_storage(file_name)

        # upload data from storage to bigquery
        # mydatabase_connector.upload_data_to_bigquery(file_name)

        # mark url as visited
        # this_time_urls.append(url)
        # with open('coepj/config/visited_urls.txt', mode='w') as f:
        #     f.write(f",{url}")


if __name__ == "__main__":
    main()
