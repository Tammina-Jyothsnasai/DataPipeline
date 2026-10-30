from extract import extract
from transform import transform
from validate import validate
from load import load

def run_pipeline():
    raw_data=extract()
    clean_data=transform(raw_data)
    validate(clean_data)
    load(clean_data)

if __name__ == "__main__":
    run_pipeline()    