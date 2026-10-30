
USE titanic_db;

-- Recreate the staging table without changing the raw table
DROP TABLE IF EXISTS stg_titanic;
CREATE TABLE stg_titanic AS
SELECT
    CAST(source_row_id AS UNSIGNED) AS source_row_id,
    CAST(survived AS UNSIGNED) AS survived,
    CAST(pclass AS UNSIGNED) AS passenger_class,
    LOWER(TRIM(sex)) AS sex,
    CAST(age AS DECIMAL(5,2)) AS age,
    CAST(sibsp AS UNSIGNED) AS siblings_spouses_aboard,
    CAST(parch AS UNSIGNED) AS parents_children_aboard,
    CAST(fare AS DECIMAL(10,4)) AS fare,
    LOWER(TRIM(embarked)) AS embarked,
    LOWER(TRIM(class)) AS class_name,
    LOWER(TRIM(who)) AS passenger_type,
    CAST(adult_male AS UNSIGNED) AS adult_male,
    LOWER(TRIM(deck)) AS deck,
    LOWER(TRIM(embark_town)) AS embark_town,
    LOWER(TRIM(alive)) AS survival_status,
    CAST(alone AS UNSIGNED) AS alone,
    CAST(load_timestamp AS DATETIME) AS load_timestamp,
    CAST(batch_id AS CHAR(36)) AS batch_id
FROM raw_titanic;
