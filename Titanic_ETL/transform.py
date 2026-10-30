def transform(df):
    df = df.copy()
 
    # Impute missing values
    df['age'] = df['age'].fillna(df['age'].median())
    df['embarked'] = df['embarked'].fillna(df['embarked'].mode()[0])
 
    # Drop sparse/redundant columns
    df = df.drop(columns=['deck', 'embark_town'])
 
    # Encode categorical column
    df['sex'] = df['sex'].map({'male': 0, 'female': 1})
 
    print(f"Transformed shape: {df.shape}")
    return df
