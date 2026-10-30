
USE titanic_db;


-- VIEW 1: Survival rate by passenger class and sex

CREATE OR REPLACE VIEW vw_survival_by_class_sex AS
SELECT
    passenger_class,
    CASE
        WHEN sex = 0 THEN 'male'
        WHEN sex = 1 THEN 'female'
        ELSE 'unknown'
    END AS sex,
    COUNT(*) AS total_passengers,
    SUM(survived) AS total_survivors,
    ROUND(AVG(survived) * 100, 2) AS survival_rate_percent
FROM clean_passengers
GROUP BY
    passenger_class,
    sex;


-- VIEW 2: Survival rate by age group

CREATE OR REPLACE VIEW vw_survival_by_age_group AS
SELECT
    age_group,
    COUNT(*) AS total_passengers,
    SUM(survived) AS total_survivors,
    ROUND(AVG(survived) * 100, 2) AS survival_rate_percent
FROM clean_passengers
GROUP BY age_group;


-- VIEW 3: Top 3 highest fares in each passenger class

CREATE OR REPLACE VIEW vw_top3_fares_per_class AS
SELECT
    passenger_class,
    passenger_class_rank,
    sex,
    age,
    fare,
    survived
FROM (
    SELECT
        passenger_class,
        ROW_NUMBER() OVER (
            PARTITION BY passenger_class
            ORDER BY fare DESC, age DESC, survived DESC
        ) AS passenger_class_rank,
        CASE
            WHEN sex = 0 THEN 'male'
            WHEN sex = 1 THEN 'female'
            ELSE 'unknown'
        END AS sex,
        age,
        fare,
        survived
    FROM clean_passengers
    WHERE fare IS NOT NULL
) AS ranked_fares
WHERE passenger_class_rank <= 3;
