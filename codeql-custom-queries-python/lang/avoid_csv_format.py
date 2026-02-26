import pandas as pd
import os

DATA_DIR = "data/exports"

def load_sales_data():
    # Case read_csv
    df = pd.read_csv("reports/sales_2024.csv")  # $ Alert
    df = df[df["revenue"] > 0]
    return df

def export_results(df, output_dir):
    os.makedirs(output_dir, exist_ok=True)

    # Case : to_csv()
    summary = df.groupby("region")["revenue"].sum()
    summary.to_csv(os.path.join(output_dir, "summary.parquet"))  # $ Alert

def get_archive_path(date):
    # Case .csv
    archive = "data/archive/transactions_2023.csv"  # $ Alert
    return os.path.join(archive, date)