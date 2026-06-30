import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv()
user = os.getenv('DB_user')
password = os.getenv('DB_password')
host = os.getenv('DB_host')
port = os.getenv('DB_port')
db = os.getenv('DB_name')

dataset_folder = 'dataset'
engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")

for table in os.listdir(dataset_folder):
    if table.endswith('.csv'):
        table_name = table.replace('.csv','').lower()
        path = os.path.join(dataset_folder, table)
        df = pd.read_csv(path)
        df.to_sql(table_name, con=engine, if_exists='append', index=False)
        print(f"{table} imported as {table_name}")
