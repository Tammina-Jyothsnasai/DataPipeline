
from datetime import datetime
from uuid import uuid4

from sqlalchemy import URL, create_engine
from config import DB_CONFIG


def load(df, table_name="raw_titanic"):
    if not DB_CONFIG["password"]:
        raise ValueError(
            "MYSQL_PASSWORD is not set. Set it in your VS Code terminal."
        )

    connection_url = URL.create(
        "mysql+mysqlconnector",
        username=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"],
        database=DB_CONFIG["database"]
    )

    engine = create_engine(connection_url)

    try:
        # Verify the MySQL connection
        with engine.connect():
            print("MySQL connection successful")

        # Add metadata only; do not clean or transform raw data
        raw_data = df.copy()
        raw_data.insert(0, "source_row_id", range(1, len(raw_data) + 1))
        raw_data["load_timestamp"] = datetime.now()
        raw_data["batch_id"] = str(uuid4())

        # Replace the previous snapshot to prevent duplicate rows
        raw_data.to_sql(
            name=table_name,
            con=engine,
            if_exists="replace",
            index=False
        )

        print(
            f"Loaded {len(raw_data)} rows into '{table_name}' table"
        )
        print("Load timestamp:", raw_data["load_timestamp"].iloc[0])
        print("Batch ID:", raw_data["batch_id"].iloc[0])

    finally:
        engine.dispose()
