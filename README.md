# Titanic Data Pipeline – ETL & ELT

A data engineering project demonstrating two approaches to building data pipelines: **ETL (Extract, Transform, Load)** and **ELT (Extract, Load, Transform)** using the Titanic dataset, Python, MySQL, and SQL.

## 📌 Project Overview

This project explores how raw data can be extracted, processed, stored, validated, and transformed into meaningful information using two different data pipeline architectures.

It contains two independent implementations:

- **Titanic ETL:** Data is extracted, cleaned, validated, and then loaded into MySQL using Python.
- **Titanic ELT:** Raw data is first loaded into MySQL, and all data cleaning and transformations are performed using SQL.

The main objective is to understand the differences between ETL and ELT, implement both workflows, automate pipeline execution, and perform data quality checks.

## 📂 Project Structure

```text
Data Pipeline/
│
├── Titanic_ETL/
│   ├── extract.py
│   ├── transform.py
│   ├── validate.py
│   ├── load.py
│   ├── pipeline.py
│   ├── batch.py
│   └── ETL.ipynb
│
├── Titanic_ELT/
│   ├── extract.py
│   ├── load.py
│   ├── config.py
│   ├── run_elt.py
│   │
│   └── sql/
│       ├── create_staging.sql
│       ├── transform_data.sql
│       ├── create_analytics.sql
│       └── data_quality.sql
│
├── requirements.txt
├── .gitignore
├── ELT.txt
└── README.md
```

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Python | Data extraction and pipeline execution |
| Pandas | Data handling |
| Seaborn | Titanic dataset extraction |
| MySQL | Data storage |
| MySQL Workbench | Database management and SQL execution |
| SQL | Data transformation, analytics, and validation |
| SQLAlchemy | Loading data into MySQL |
| MySQL Connector | Database connectivity |
| Git & GitHub | Version control and project hosting |
| VS Code | Development environment |

## 1. ETL Pipeline

**ETL stands for Extract, Transform, Load.**

In this approach, data is cleaned and transformed before it is loaded into the target database.

### Workflow

```text
Titanic Dataset
       |
       v
    Extract
       |
       v
   Transform
       |
       v
    Validate
       |
       v
      Load
       |
       v
   MySQL Database
```

### Implementation

1. **Extract:** Retrieve the Titanic dataset using Python and Seaborn.
2. **Transform:** Handle missing values and perform the required data cleaning operations.
3. **Validate:** Check the transformed data for quality and consistency.
4. **Load:** Store the processed data in MySQL.

### Main Files

- `extract.py` – Extracts the Titanic dataset.
- `transform.py` – Performs data cleaning and transformation.
- `validate.py` – Validates the processed data.
- `load.py` – Loads the processed data into MySQL.
- `pipeline.py` – Coordinates the ETL workflow.
- `batch.py` – Supports batch processing.

## 2. ELT Pipeline

**ELT stands for Extract, Load, Transform.**

In this approach, raw data is loaded into the database first. Data cleaning and transformation are performed inside the database using SQL.

### Workflow

```text
Titanic Dataset
       |
       v
    Extract
       |
       v
      Load
       |
       v
  raw_titanic
       |
       v
  stg_titanic
       |
       v
 clean_passengers
       |
       v
 Analytics Views
       |
       v
 Data Quality Checks
```

### Implementation

**Step 1: Extract**

- Extracted the Titanic dataset using Seaborn.
- Retrieved 891 records and 15 original columns.

**Step 2: Load**

- Loaded the original dataset into the `raw_titanic` table.
- Added `source_row_id`, `load_timestamp`, and `batch_id` as metadata.
- Preserved the raw source values without performing data cleaning in Python.

**Step 3: Transform**

Performed transformations using SQL:

- Handled missing age values using passenger class and sex-based averages.
- Replaced missing embarked values using the most frequent value.
- Encoded sex values as male = 0 and female = 1.
- Created age groups: Child, Teen, Adult, and Senior.
- Calculated family size.
- Identified passengers travelling alone.
- Categorized fares into Low, Medium, High, and Premium using quartiles.

**Step 4: Analytics**

Created the following analytical views:

| View | Purpose |
|---|---|
| `vw_survival_by_class_sex` | Analyzes survival rates by passenger class and sex |
| `vw_survival_by_age_group` | Analyzes survival rates across age groups |
| `vw_top3_fares_per_class` | Identifies the top three fares in each passenger class |

**Step 5: Data Quality Checks**

Implemented five SQL-based data quality checks:

1. Age values must be between 0 and 100.
2. Source row IDs must be unique and non-NULL.
3. Age and embarked columns must not contain NULL values.
4. Raw and clean table row counts must match.
5. Sex values must contain only 0 and 1.

## ⚙️ ELT Pipeline Automation

The `run_elt.py` file automates the complete ELT workflow.

It performs the following operations:

1. Extracts the Titanic dataset.
2. Loads raw data into MySQL.
3. Executes the SQL files in the correct order.
4. Retrieves the data quality results.
5. Prints PASS or FAIL for each check.
6. Displays the overall pipeline status.

### Execution Command

```bash
python run_elt.py
```

### Expected Results

- 891 records extracted.
- 891 records loaded into `raw_titanic`.
- Staging and clean tables created successfully.
- Three analytics views created.
- Five data quality checks executed.

**Latest successful execution:** All five data quality checks returned PASS.

## 💻 Installation and Setup

### Prerequisites

- Python 3.x
- MySQL Server
- MySQL Workbench
- Visual Studio Code
- Git

### Step 1: Clone the Repository

```bash
git clone https://github.com/Tammina-Jyothsnasai/DataPipeline.git
```

### Step 2: Navigate to the Project

```bash
cd DataPipeline
```

### Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

### Step 4: Create the MySQL Database

Execute the following query in MySQL Workbench:

```sql
CREATE DATABASE IF NOT EXISTS titanic_db;
```

### Step 5: Configure Database Credentials

Set your MySQL password as an environment variable.

**Windows PowerShell:**

```powershell
$env:MYSQL_PASSWORD = "YOUR_MYSQL_PASSWORD"
```

Ensure that the database connection settings in `Titanic_ELT/config.py` and the ETL configuration are correct.

### Step 6: Run the ELT Pipeline

```bash
cd Titanic_ELT
python run_elt.py
```

The script automatically performs extraction, loading, SQL transformations, analytics creation, and data quality checks.

## 📊 ETL vs ELT Comparison

| Feature | ETL | ELT |
|---|---|---|
| Full form | Extract, Transform, Load | Extract, Load, Transform |
| Transformation | Before loading | After loading |
| Processing | Python | SQL |
| Raw data storage | Depends on implementation | Preserved in raw table |
| Database role | Stores processed data | Stores and transforms data |
| Main advantage | Data is cleaned before loading | Uses database processing capabilities |

## 🎯 Key Learnings

Through this project, I gained practical experience in:

- Understanding ETL and ELT architectures.
- Extracting datasets using Python.
- Working with Pandas and Seaborn.
- Connecting Python applications with MySQL.
- Writing SQL queries for data transformation.
- Handling missing values and encoding categorical data.
- Creating analytical views using SQL.
- Implementing data quality checks.
- Automating data pipeline execution.
- Using Git and GitHub for version control.

## 👩‍💻 Author

**T. Jyothsna Sai**

B.Tech – Computer Science and Engineering

GitHub: [Tammina-Jyothsnasai](https://github.com/Tammina-Jyothsnasai)

---

⭐ This project demonstrates the practical implementation of ETL and ELT concepts using a common dataset and highlights how Python and SQL work together in data engineering.
