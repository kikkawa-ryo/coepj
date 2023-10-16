from dotenv import load_dotenv
import os

# .env ファイルをロードして環境変数へ反映
load_dotenv()
GOOGLE_APPLICATION_CREDENTIALS = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")

# データベース接続情報
BUCKET_NAME = 'coffee_bucket'

# スクレイピングの設定
RESULT_URL = "https://allianceforcoffeeexcellence.org/competition-auction-results/"
SCRAPING_FREQUENCY = 1.5  # 秒単位で指定

# データ収集の設定
DATA_FORMAT = 'csv'
DATA_LOCATION = '/data/my_data.csv'

# エラー処理の設定
ERROR_LOG_LOCATION = '/logs/error.log'
MAX_RETRIES = 3
RETRY_INTERVAL = 10  # 秒単位で指定
