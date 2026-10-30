def validate(df):
    assert df.isnull().sum().sum() == 0,"Nullls still present!"
    assert df['sex'].isin([0,1]).all(),"Sex not fully encoded!"
    print("Validation passed ")