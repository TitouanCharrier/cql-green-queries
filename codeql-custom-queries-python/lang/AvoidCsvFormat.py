import pandas as pd

# should flag 4 times
def test_csv_usage():
    df = pd.read_csv("data.csv")
    
    df.to_csv("output.csv")
    
    file_path = "import/manual_load.CSV"
    
    name = "report"
    full_path = name + ".csv"

# should not flag
def test_valid_usage():
    df_parquet = pd.read_parquet("data.parquet")
    
    df_feather = pd.read_feather("data.feather")
    
    description = "Ceci est un fichier de données"
    
    valid_string = "csv_processor.py"