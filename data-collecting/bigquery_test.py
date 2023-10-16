import pandas as pd
from google.cloud import bigquery

import config.settings as settings

# Construct a BigQuery client object.
client = bigquery.Client()

query = """
    SELECT
        url
    FROM
        `coffee-research.datalake.test`
"""
query_job = client.query(query)  # Make an API request.

results = query_job.result()
# df = pd.DataFrame(
#     [(row["url"], row[1]) for row in results],
#     columns=["url", "content"],
# )
visited_urls = [row["url"] for row in results]
# print(df)


print(visited_urls)

# print("The query data:")
# for row in query_job:
#     # Row values can be accessed by field name or index.
#     print(row)

# print(settings.GOOGLE_APPLICATION_CREDENTIALS)

