
import seaborn as sns   # type: ignore[reportMissingModuleSource]


def extract():
    df = sns.load_dataset("titanic")

    print(f"Extracted {len(df)} rows and {len(df.columns)} columns")
    print("Original columns:", df.columns.tolist())

    return df


if __name__ == "__main__":
    raw_data = extract()
    print(raw_data.head())
