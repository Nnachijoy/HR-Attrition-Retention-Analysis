
-- EMPLOYEE ATTRITION & RETENTION ANALYSIS

-- SECTION 1: DATA QUALITY CHECKS
-- Check for missing values in important columns

SELECT
    COUNT(*) FILTER (WHERE employeeid IS NULL) AS employeeid_missing,
    COUNT(*) FILTER (WHERE recorddate_key IS NULL) AS recorddate_missing,
    COUNT(*) FILTER (WHERE birthdate_key IS NULL) AS birthdate_missing,
    COUNT(*) FILTER (WHERE orighiredate_key IS NULL) AS hiredate_missing,
    COUNT(*) FILTER (WHERE terminationdate_key IS NULL) AS terminationdate_missing,
    COUNT(*) FILTER (WHERE age IS NULL) AS age_missing,
    COUNT(*) FILTER (WHERE length_of_service IS NULL) AS service_missing,
    COUNT(*) FILTER (WHERE department_name IS NULL) AS department_missing,
    COUNT(*) FILTER (WHERE job_title IS NULL) AS job_title_missing,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_missing,
    COUNT(*) FILTER (WHERE business_unit IS NULL) AS business_unit_missing
FROM employee_data;


-- SECTION 2: DATA CLEANING
-- Replace the 1900-01-01 placeholder with NULL

UPDATE employee_data
SET terminationdate_key = NULL
WHERE terminationdate_key = '1900-01-01';

-- Verify termination date values after cleaning

SELECT
    COUNT(*) FILTER (WHERE terminationdate_key IS NULL) AS no_termination_date,
    COUNT(*) FILTER (WHERE terminationdate_key IS NOT NULL) AS has_termination_date
FROM employee_data;


-- SECTION 3: DATA VALIDATION
-- Check employee status values

SELECT
    status,
    COUNT(*) AS record_count
FROM employee_data
GROUP BY status
ORDER BY record_count DESC;


-- Check termination types

SELECT
    termtype_desc,
    COUNT(*) AS record_count
FROM employee_data
GROUP BY termtype_desc
ORDER BY record_count DESC;


-- Check termination reasons

SELECT
    termreason_desc,
    COUNT(*) AS record_count
FROM employee_data
GROUP BY termreason_desc
ORDER BY record_count DESC;

-- SECTION 4: BUSINESS ANALYSIS
-- ANALYSIS 1: Total number of unique employees

SELECT
    COUNT(DISTINCT employeeid) AS total_employees
FROM employee_data;


-- ANALYSIS 2: Unique employees by department

SELECT
    department_name,
    COUNT(DISTINCT employeeid) AS total_employees
FROM employee_data
GROUP BY department_name
ORDER BY total_employees DESC;


-- ANALYSIS 3: Unique employees by business unit

SELECT
    business_unit,
    COUNT(DISTINCT employeeid) AS total_employees
FROM employee_data
GROUP BY business_unit
ORDER BY total_employees DESC;


-- ANALYSIS 4: Unique employees by gender

SELECT
    gender_full,
    COUNT(DISTINCT employeeid) AS total_employees
FROM employee_data
GROUP BY gender_full
ORDER BY total_employees DESC;


-- ANALYSIS 5: Unique employees by job title

SELECT
    job_title,
    COUNT(DISTINCT employeeid) AS total_employees
FROM employee_data
GROUP BY job_title
ORDER BY total_employees DESC;


-- ANALYSIS 6: Average length of service

SELECT
    ROUND(AVG(length_of_service), 2) AS average_length_of_service
FROM employee_data;

-- ANALYSIS 7: Overall termination rate

SELECT
    ROUND(
        COUNT(*) FILTER (WHERE status = 'TERMINATED') * 100.0
        / COUNT(*),
        2
    ) AS termination_rate
FROM employee_data;

-- ANALYSIS 8: Terminations by department

SELECT
    department_name,
    COUNT(*) AS total_terminations
FROM employee_data
WHERE status = 'TERMINATED'
GROUP BY department_name
ORDER BY total_terminations DESC;

-- ANALYSIS 9: Terminations by year

SELECT
    status_year,
    COUNT(*) AS total_terminations
FROM employee_data
WHERE status = 'TERMINATED'
GROUP BY status_year
ORDER BY status_year;

-- ANALYSIS 10: Average tenure of terminated employees

SELECT
    ROUND(AVG(length_of_service), 2) AS avg_tenure_terminated
FROM employee_data
WHERE status = 'TERMINATED';

-- ANALYSIS 11: Most common termination reasons

SELECT
    termreason_desc AS termination_reason,
    COUNT(*) AS total_terminations
FROM employee_data
WHERE status = 'TERMINATED'
GROUP BY termreason_desc
ORDER BY total_terminations DESC;

-- ANALYSIS 12: Turnover rate by department

SELECT
    department_name,
    COUNT(DISTINCT employeeid) AS total_employees,
    COUNT(DISTINCT employeeid) FILTER (
        WHERE status = 'TERMINATED'
    ) AS terminated_employees,
    ROUND(
        COUNT(DISTINCT employeeid) FILTER (
            WHERE status = 'TERMINATED'
        ) * 100.0
        / COUNT(DISTINCT employeeid),
        2
    ) AS turnover_rate
FROM employee_data
GROUP BY department_name
ORDER BY turnover_rate DESC;


-- ANALYSIS 13: Year-over-year turnover analysis

WITH yearly_summary AS (
    SELECT
        status_year,
        COUNT(*) AS total_records,
        COUNT(*) FILTER (
            WHERE status = 'TERMINATED'
        ) AS terminated_employees
    FROM employee_data
    GROUP BY status_year
),

yearly_turnover AS (
    SELECT
        status_year,

        ROUND(
            terminated_employees * 100.0 / total_records,
            2
        ) AS turnover_rate,

        LAG(
            ROUND(
                terminated_employees * 100.0 / total_records,
                2
            )
        ) OVER (
            ORDER BY status_year
        ) AS previous_year_turnover

    FROM yearly_summary
),

turnover_analysis AS (
    SELECT
        status_year,
        turnover_rate,
        previous_year_turnover,

        ROUND(
            turnover_rate - previous_year_turnover,
            2
        ) AS yoy_change,

        CASE
            WHEN previous_year_turnover IS NULL
                THEN 'N/A'
            WHEN turnover_rate > previous_year_turnover
                THEN 'Increased'
            WHEN turnover_rate < previous_year_turnover
                THEN 'Decreased'
            ELSE 'No Change'
        END AS turnover_direction

    FROM yearly_turnover
)

SELECT
    status_year,
    turnover_rate,
    previous_year_turnover,
    yoy_change,
    turnover_direction,

    RANK() OVER (
        ORDER BY turnover_rate DESC
    ) AS turnover_rank

FROM turnover_analysis
ORDER BY turnover_rank;