import seaborn as sns  # type: ignore[reportMissingModuleSource]

def extract():
    df = sns.load_dataset('titanic')
    print(f"Extracted {len(df)} rows,{len(df.columns)} columns")
    return df
