
from pathlib import Path

import mysql.connector

from config import DB_CONFIG
from extract import extract
from load import load


BASE_DIR = Path(__file__).resolve().parent

SQL_FILES = [
    "create_staging.sql",
    "transform_data.sql",
    "create_analytics.sql",
    "data_quality.sql",
]


def run_sql_file(cursor, file_name):
    """Execute all SQL statements in one file."""
    file_path = BASE_DIR / "sql" / file_name

    if not file_path.exists():
        raise FileNotFoundError(f"SQL file not found: {file_path}")

    sql_text = file_path.read_text(encoding="utf-8")

    # Remove standalone SQL comment lines
    lines = [
        line for line in sql_text.splitlines()
        if not line.strip().startswith("--")
    ]

    statements = "\n".join(lines).split(";")

    for statement in statements:
        statement = statement.strip()

        if statement:
            cursor.execute(statement)

            # Clear results if a statement returns rows
            if cursor.with_rows:
                cursor.fetchall()

    print(f"PASS: {file_name} executed successfully")


def print_quality_results(cursor):
    """Print PASS or FAIL for every data quality check."""
    cursor.execute("""
        SELECT check_name, status
        FROM dq_results
        ORDER BY check_name
    """)

    results = cursor.fetchall()

    if not results:
        print("FAIL: No data quality results found.")
        return False

    all_passed = True

    print("\n--- DATA QUALITY RESULTS ---")

    for check_name, status in results:
        print(f"{status}: {check_name}")

        if status != "PASS":
            all_passed = False

    print("----------------------------")
    print("Overall:", "PASS" if all_passed else "FAIL")

    return all_passed


def run_elt():
    connection = None
    cursor = None

    try:
        print("Starting Titanic ELT pipeline...\n")

        # Step 1: Extract and load the raw data
        raw_data = extract()
        load(raw_data)

        print("\nPASS: Extraction and loading completed")

        # Step 2: Run the SQL files in order
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor()

        for file_name in SQL_FILES:
            run_sql_file(cursor, file_name)

        # Step 3: Display the five quality checks
        print_quality_results(cursor)

        print("\nELT pipeline finished.")

    except Exception as error:
        print(f"\nFAIL: ELT pipeline stopped: {error}")
        raise

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None and connection.is_connected():
            connection.close()


if __name__ == "__main__":
    run_elt()
