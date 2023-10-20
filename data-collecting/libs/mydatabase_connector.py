from google.cloud import storage
from google.cloud import bigquery

import config.settings as settings

def get_visited_urls():
    # Construct a BigQuery client object.
    client = bigquery.Client()
    query = """
        SELECT DISTINCT
            url
        FROM
            `coffee-research.datalake.coe_results`
    """
    query_job = client.query(query)  # Make an API request.
    results = query_job.result()
    visited_urls = [row["url"] for row in results]
    return visited_urls

def upload_data_to_storage(file_name):
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(settings.BUCKET_NAME)

    blob = bucket.blob(f'coe_results/results/{file_name}.csv')
    blob.upload_from_filename(filename=f'data-collecting/data/tmp.csv')

