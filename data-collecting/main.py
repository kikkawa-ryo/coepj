def main():
    import json

    from libs import mycrawler
    from libs import database
    from config import settings

    # get visited urls
    with open('coepj/config/visited_urls.txt') as f:
        visited_urls_str = f.read()
        # str to list
        visited_urls = visited_urls_str.split(',')
    # prepare start url and get target urls
    start_url = settings.RESULT_URL
    target_urls = mycrawler.crawl_start_link(start_url)
    # make this time links list
    this_time_urls = []
    # crawl target url
    for url in target_urls:
        print(url)

        # if ("2021" in url) or ("2022" in url):
        #     continue
        # if "2022" in url:
        #     detail_crawler = mycrawler.Crawler(url)
        #     # crawl
        #     detail_crawler.crawl()
        #     print()
        #     continue
        # else:
        #     continue

        # not visited
        if url not in visited_urls:
            # generate instance
            detail_crawler = mycrawler.Crawler(url)
            # crawl
            detail_crawler.crawl()

            # check whether extraction went well
            # confirmation = input("")
            # if confirmation.lower() == "y":
            #     # continue to process
            #     pass
            # else:
            #     break
            

            # save json file at local
            file_name = detail_crawler.result['program'].lower().replace(
                ' ', '-')
            with open(f'coepj/results/{file_name}.json', 'w', encoding='utf-8') as f:
                json.dump(detail_crawler.result, f, ensure_ascii=False)

            # upload data from local to storage
            database.upload_data_to_storage(file_name)

            # upload data from storage to bigquery
            database.upload_data_to_bigquery(file_name)

            # mark url as visited
            this_time_urls.append(url)
            with open('coepj/config/visited_urls.txt', mode='w') as f:
                f.write(f",{url}")


if __name__ == "__main__":
    main()
