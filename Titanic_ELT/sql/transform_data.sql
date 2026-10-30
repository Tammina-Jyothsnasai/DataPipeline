
USE titanic_db;

DROP TABLE IF EXISTS clean_passengers;

-- Step 1: Fill missing age and embarked values
CREATE TABLE clean_passengers AS
WITH age_filled AS (
    SELECT
        source_row_id,
        survived,
        passenger_class,
        sex,
        COALESCE(
            age,
            AVG(age) OVER (
                PARTITION BY passenger_class, sex
            )
        ) AS age,
        siblings_spouses_aboard,
        parents_children_aboard,
        fare,
        COALESCE(
            embarked,
            (
                SELECT embarked
                FROM stg_titanic
                WHERE embarked IS NOT NULL
                GROUP BY embarked
                ORDER BY COUNT(*) DESC, embarked
                LIMIT 1
            )
        ) AS embarked,
        class_name,
        passenger_type,
        adult_male,
        survival_status,
        load_timestamp,
        batch_id
    FROM stg_titanic
),

-- Step 2: Encode sex
encoded AS (
    SELECT
        source_row_id,
        survived,
        passenger_class,
        CASE
            WHEN sex = 'male' THEN 0
            WHEN sex = 'female' THEN 1
        END AS sex,
        age,
        siblings_spouses_aboard,
        parents_children_aboard,
        fare,
        embarked,
        class_name,
        passenger_type,
        adult_male,
        survival_status,
        load_timestamp,
        batch_id
    FROM age_filled
),

-- Step 3: Create derived columns
derived AS (
    SELECT
        source_row_id,
        survived,
        passenger_class,
        sex,
        age,
        siblings_spouses_aboard,
        parents_children_aboard,
        fare,
        embarked,
        class_name,
        passenger_type,
        adult_male,
        survival_status,
        load_timestamp,
        batch_id,

        CASE
            WHEN age >= 0 AND age < 13 THEN 'Child'
            WHEN age >= 13 AND age < 20 THEN 'Teen'
            WHEN age >= 20 AND age < 60 THEN 'Adult'
            WHEN age >= 60 THEN 'Senior'
            ELSE 'Unknown'
        END AS age_group,

        siblings_spouses_aboard
            + parents_children_aboard + 1 AS family_size,

        CASE
            WHEN siblings_spouses_aboard = 0
             AND parents_children_aboard = 0 THEN 1
            ELSE 0
        END AS is_alone

    FROM encoded
),

-- Step 4: Divide fares into four quartiles
fare_ranked AS (
    SELECT
        derived.*,
        NTILE(4) OVER (ORDER BY fare) AS fare_quartile
    FROM derived
)

-- Step 5: Create the final clean table
SELECT
    source_row_id,
    survived,
    passenger_class,
    sex,
    age,
    siblings_spouses_aboard,
    parents_children_aboard,
    fare,
    embarked,
    class_name,
    passenger_type,
    adult_male,
    survival_status,
    age_group,
    family_size,
    is_alone,

    CASE fare_quartile
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Premium'
    END AS fare_category,

    load_timestamp,
    batch_id

FROM fare_ranked;
