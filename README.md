# Public Distribution System (PDS) & Ration Distribution Analytics

A practical, government-domain SQL portfolio project that analyses ration shops, beneficiaries, monthly allocations, distribution transactions, and stock availability.

This project is designed to be **similar in difficulty to a beginner-to-intermediate SQL analytics project**. It complements the Government Healthcare Resource & Hospital Analytics project without introducing more advanced SQL concepts.

> Educational portfolio project with fictional sample data. It is not connected to any government system and must not be used for real beneficiary decisions.

## Project objectives

- Track ration shops and the districts they serve.
- Maintain beneficiary and ration-card information.
- Store monthly commodity allocations for each shop.
- Record ration distribution transactions.
- Monitor shop-level stock and identify low-stock items.
- Analyse monthly distribution, beneficiary activity, and shop performance.

## SQL concepts used

- Database and table creation
- Primary keys and foreign keys
- `NOT NULL`, `UNIQUE`, `CHECK`, and default values
- `INSERT`, `UPDATE`, and `SELECT`
- `INNER JOIN` and `LEFT JOIN`
- `GROUP BY`, `HAVING`, and aggregate functions
- Subqueries
- `CASE` statements
- Date functions
- Views
- Basic indexes
- One stored procedure for a monthly shop summary

No window functions, triggers, or complex CTE workflows are required in this project. The aim is to practise core SQL confidently.

## Folder structure

```text
public_distribution_system_analytics/
├── README.md
├── requirements.txt
├── .gitignore
├── sql/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_views_indexes.sql
│   └── 04_analysis_queries.sql
└── python/
    ├── db_connection.py
    └── distribution_report.py
```

## Requirements

- MySQL Server 8.0+
- MySQL Workbench (recommended)
- Python 3.9+ (optional, only for the Python report)

## Setup instructions

### Step 1: Open MySQL Workbench

Connect to your local MySQL server.

### Step 2: Execute SQL files in order

Run these files one by one:

1. `sql/01_schema.sql`
2. `sql/02_sample_data.sql`
3. `sql/03_views_indexes.sql`
4. `sql/04_analysis_queries.sql`

The first script creates and selects the database `pds_analytics`.

### Step 3: Explore the tables

```sql
USE pds_analytics;
SHOW TABLES;
SELECT * FROM Beneficiaries;
SELECT * FROM Ration_Shops;
SELECT * FROM Distribution_Transactions;
```

### Step 4: Optional Python connection

Install dependencies:

```bash
pip install -r requirements.txt
```

Set credentials using environment variables.

**Windows PowerShell**
```powershell
$env:DB_HOST="localhost"
$env:DB_USER="root"
$env:DB_PASSWORD="your_mysql_password"
$env:DB_NAME="pds_analytics"
python python/distribution_report.py
```

**macOS/Linux**
```bash
export DB_HOST="localhost"
export DB_USER="root"
export DB_PASSWORD="your_mysql_password"
export DB_NAME="pds_analytics"
python python/distribution_report.py
```

Never commit your database password to GitHub.

## Main tables

| Table | Purpose |
|---|---|
| `Districts` | District and state details |
| `Ration_Shops` | Fair Price Shop details |
| `Beneficiaries` | Fictional ration-card holders |
| `Commodities` | Items such as rice, wheat and sugar |
| `Monthly_Allocations` | Monthly quantity allocated to shops |
| `Distribution_Transactions` | Actual quantities distributed |

## Suggested GitHub description

**Public Distribution System (PDS) & Ration Distribution Analytics | MySQL, SQL, Python**

Built a relational database to analyse ration distribution across fair price shops, including beneficiary records, monthly commodity allocations, distribution transactions, stock monitoring, SQL joins, aggregations, subqueries, views, and Python-MySQL connectivity.

## Suggested practice tasks

1. Find the total number of beneficiaries in each district.
2. Calculate the total quantity of each commodity distributed.
3. Find shops that distributed more than 1000 kg in a month.
4. Identify beneficiaries who have not collected ration in the sample period.
5. Compare allocated quantity with distributed quantity for each shop.
6. Find the top-performing ration shop by total distribution.
7. Use `EXPLAIN` on a query filtering transactions by date and shop.

## Important limitations

- All records are fictional.
- This demo does not connect to Aadhaar, government portals, or live PDS databases.
- It does not implement real entitlement rules, identity verification, or payment systems.
- The stored procedure is a reporting helper, not a production ration-issue workflow.
