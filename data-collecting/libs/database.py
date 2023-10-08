from google.cloud import storage
from google.cloud import bigquery
from config import settings


def upload_data_to_storage(file_name):
    storage_client = storage.Client.from_service_account_json(
        settings.GOOGLE_APPLICATION_CREDENTIALS)
    bucket = storage_client.get_bucket(settings.BUCKET_NAME)

    blob = bucket.blob(f'coe_results/results/{file_name}.json')
    blob.upload_from_filename(filename=f'coepj/results/{file_name}.json')


def upload_data_to_bigquery(file_name):
    bigquery_client = bigquery.Client().from_service_account_json(
        settings.GOOGLE_APPLICATION_CREDENTIALS)
    dataset_id = 'coffee-research.datalake'

    dataset_ref = bigquery_client.dataset(dataset_id)
    job_config = bigquery.LoadJobConfig()
    job_config.autodetect = True
    job_config.source_format = bigquery.SourceFormat.NEWLINE_DELIMITED_JSON
    uri = f"gs://coffee_bucket/coe_results/results/{file_name}.json"
    load_job = bigquery_client.load_table_from_uri(
        uri, dataset_ref.table(file_name), job_config=job_config
    )  # API request
    print("Starting job {}".format(load_job.job_id))

    load_job.result()  # Waits for table load to complete.
    print("Job finished.")

    destination_table = bigquery_client.get_table(dataset_ref.table(file_name))
    print("Loaded {} rows.".format(destination_table.num_rows))
