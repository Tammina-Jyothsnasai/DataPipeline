
USE titanic_db;

-- 1. Create the data quality results table
CREATE TABLE IF NOT EXISTS dq_results (
    check_name VARCHAR(100) NOT NULL,
    status VARCHAR(10) NOT NULL,
    checked_at DATETIME NOT NULL
);

-- Keep only the latest run's results
TRUNCATE TABLE dq_results;


-- CHECK 1: Raw row count must equal clean row count
INSERT INTO dq_results (check_name, status, checked_at)
SELECT
    'Raw and clean row counts match',
    CASE
        WHEN (SELECT COUNT(*) FROM raw_titanic) =
             (SELECT COUNT(*) FROM clean_passengers)
        THEN 'PASS'
        ELSE 'FAIL'
    END,
    CURRENT_TIMESTAMP;


-- CHECK 2: No NULL values in age or embarked
INSERT INTO dq_results (check_name, status, checked_at)
SELECT
    'No NULL values in age and embarked',
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    CURRENT_TIMESTAMP
FROM clean_passengers
WHERE age IS NULL
   OR embarked IS NULL;


-- CHECK 3: Every source row ID must be unique and non-NULL
INSERT INTO dq_results (check_name, status, checked_at)
SELECT
    'No duplicate source row IDs',
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT source_row_id)
         AND COUNT(source_row_id) = COUNT(*)
        THEN 'PASS'
        ELSE 'FAIL'
    END,
    CURRENT_TIMESTAMP
FROM clean_passengers;


-- CHECK 4: Age must be between 0 and 100
INSERT INTO dq_results (check_name, status, checked_at)
SELECT
    'Age is between 0 and 100',
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    CURRENT_TIMESTAMP
FROM clean_passengers
WHERE age < 0
   OR age > 100;


-- CHECK 5: Sex must contain only 0 or 1
INSERT INTO dq_results (check_name, status, checked_at)
SELECT
    'Sex contains only 0 and 1',
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    CURRENT_TIMESTAMP
FROM clean_passengers
WHERE sex IS NULL
   OR sex NOT IN (0, 1);


-- Display the results of all five checks
SELECT
    check_name,
    status,
    checked_at
FROM dq_results
ORDER BY check_name;
