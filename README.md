# HR Attrition & Retention Analysis

## Project Overview

This project analyzes workforce composition, employee tenure, termination patterns, and attrition drivers to support HR decision-making and retention planning.

The analysis combines **PostgreSQL** for data preparation and SQL analysis with **Power BI** for interactive dashboard reporting.

## Business Objective

The HR department wants to understand:

- Workforce composition across departments, business units, genders, and job roles
- Employee tenure and workforce structure
- Employee termination patterns over time
- The main reasons employees leave
- Departments with high termination activity
- Changes in termination levels year over year
- Areas where management should investigate and strengthen retention

## Dataset

**Source:** Kaggle — HR Analytics: Employee Attrition & Retention Dataset

The dataset contains employee status records with information including:

- Employee ID
- Record date
- Birth date
- Hire date
- Termination date
- Age
- Length of service
- Department
- Job title
- Store
- Gender
- Termination reason
- Termination type
- Status year
- Employee status
- Business unit

The dataset contains **49,653 employee status records representing 6,284 unique employees**.

> **Important data-grain note:** The dataset is not one row per employee. Employees can appear in multiple yearly status records. Therefore, unique workforce counts use `COUNT(DISTINCT employeeid)`.

## Tools Used

- **PostgreSQL / pgAdmin** — data cleaning, validation and SQL analysis
- **Power BI** — dashboard development and visualization
- **DAX** — calculated measures and workforce analysis

## Data Preparation

The data preparation process included:

1. Checking important fields for missing values
2. Validating employee status, termination type and termination reason
3. Identifying the `1900-01-01` termination-date placeholder
4. Replacing the placeholder with `NULL` to represent employees without an actual termination date
5. Validating the cleaned dataset before analysis

## SQL Analysis

The SQL analysis answers the major business questions, including:

- Total number of unique employees
- Headcount by department
- Headcount by business unit
- Headcount by gender
- Headcount by job title
- Average length of service
- Overall termination rate
- Terminations by department
- Terminations by year
- Average tenure of terminated employees
- Most common termination reasons
- Department termination rates
- Year-over-year termination analysis using:
  - CTEs
  - `CASE`
  - `LAG()`
  - `RANK()`

## Key Findings

### Workforce

The dataset represents **6,284 unique employees**.

The workforce is heavily concentrated in the **STORES** business unit, with a much smaller HEADOFFICE workforce.

The largest departments include:

- Meats
- Customer Service
- Produce
- Dairy
- Bakery
- Processed Foods

### Gender

The workforce is relatively balanced:

- Female: **3,278**
- Male: **3,006**

### Tenure

Average recorded length of service is approximately **10.43 years**.

Terminated records have an average tenure of approximately **11.36 years**.

This indicates that employee exits are not limited to recent hires; a substantial amount of experienced workforce is represented among termination records.

### Terminations

There are **1,485 termination records** in the dataset.

The calculated record-level termination rate is approximately **2.99%**.

### Termination Reasons

The most common termination reasons are:

| Termination Reason | Records |
|---|---:|
| Retirement | 885 |
| Resignaton | 385 |
| Layoff | 215 |

The dataset contains the spelling **"Resignaton"** as provided in the source data.

### Termination Trend

Termination activity was highest in **2014**, with **253 termination records**.

The calculated termination rate increased from approximately **1.97% in 2013** to **4.85% in 2014**, before declining in 2015.

## Management Recommendations

### 1. Investigate the 2014 termination spike

Management should investigate the organizational, operational or workforce factors that contributed to the sharp increase in termination activity during 2014.

### 2. Focus on voluntary exits

Voluntary termination records substantially exceed involuntary termination records. HR should investigate potential drivers such as employee satisfaction, career progression, compensation, workload and management practices.

### 3. Strengthen succession planning

Because terminated records have relatively high average tenure and retirement is the most common termination reason, management should strengthen succession planning, knowledge transfer and workforce replacement strategies.

### 4. Prioritize high-volume departments

Large operational departments such as Meats, Produce, Customer Service and Dairy account for substantial termination activity and should receive closer retention analysis.

### 5. Interpret small departments carefully

Some small departments show very high termination percentages because of their small employee populations. These rates should not be interpreted in the same way as termination patterns in larger departments.

## Power BI Dashboard

The Power BI report contains three pages:

### Page 1 — Executive HR Overview

Provides a management-level summary of:

- Total employees
- Total terminations
- Termination rate
- Average tenure
- Termination trend
- Termination reasons
- Workforce by department
- Gender mix

### Page 2 — Workforce Analysis

Explores:

- Workforce by department
- Top 10 job titles
- Gender distribution
- Business unit composition
- Workforce age groups

### Page 3 — Attrition & Retention Insights

Examines:

- Total terminations
- Voluntary vs involuntary terminations
- Terminations over time
- Terminations by department
- Termination reasons by department
- Management recommendations

## Important Analytical Note

The **2.99% termination rate is a record-level rate based on the employee status records in the dataset**. It should not be interpreted as a conventional annual employee turnover rate based on average headcount.

This distinction is important because the dataset contains multiple records for some employees across different years.

## Project Files

- `HR_Attrition_Analysis.sql` — SQL cleaning, validation and analysis queries
- `HR_Attrition_Retention_Dashboard.pbix` — Power BI dashboard

## Conclusion

This project demonstrates an end-to-end HR analytics workflow, from data cleaning and SQL analysis to interactive business intelligence reporting.

The analysis highlights workforce composition, termination patterns and potential retention priorities that HR management can investigate further.
