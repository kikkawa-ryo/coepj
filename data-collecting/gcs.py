from google.cloud import storage
import config.settings as settings
storage_client = storage.Client.from_service_account_json(
    settings.GOOGLE_APPLICATION_CREDENTIALS)
bucket = storage_client.get_bucket(settings.BUCKET_NAME)

blob = bucket.blob('test/res.json')
blob.upload_from_filename(filename='coepj/results/res.json')
