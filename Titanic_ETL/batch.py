# batch_pipeline.py
"""Run the Titanic ETL pipeline in batches instead of processing all rows at once."""
import argparse
 
from extract import extract
from transform import transform
from validate import validate
from load import load
 
def run_batch_pipeline(batch_size=100, table_name="passengers"):
    if batch_size < 1:
        raise ValueError("batch_size must be at least 1")
 
    raw = extract()
    total_rows = len(raw)
    if total_rows == 0:
        print("No rows found; nothing to load.")
        return
 
    print(f"Starting batch ETL: {total_rows} rows, batch size {batch_size}")
    loaded_rows = 0
 
    for batch_number, start in enumerate(range(0, total_rows, batch_size), start=1):
        batch = raw.iloc[start:start + batch_size].copy()
        print(f"\nProcessing batch {batch_number}: rows {start + 1}-{start + len(batch)}")
 
        clean_batch = transform(batch)
        validate(clean_batch)
 
        # Create/replace the table for the first batch; append subsequent batches.
        mode = "replace" if batch_number == 1 else "append"
        load(clean_batch, table_name=table_name, if_exists=mode)
        loaded_rows += len(clean_batch)
 
    print(f"\nBatch ETL completed. Loaded {loaded_rows} rows into '{table_name}'.")
 
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run Titanic ETL with batch processing.")
    parser.add_argument("--batch-size", type=int, default=100, help="Number of rows per batch (default: 100)")
    parser.add_argument("--table", default="passengers", help="Destination MySQL table (default: passengers)")
    args = parser.parse_args()
    run_batch_pipeline(batch_size=args.batch_size, table_name=args.table)