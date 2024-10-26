# Introduction
Dive into the data job market! 📊 Focusing on data analyst roles, this project explores 💰 top-paying jobs, in-demand skills, and where high demand meets high salary in Data Analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/).

# Background
This project was born from a desire to analyze top-paid and in-demand skills for Data Analysis, and as a way to practice SQL queries. This project aims to help prospective data analysts going into the job market.

The CSV files used in this project can be found [here](https://lukeb.co/sql_project_csvs).

## This project answers 5 main questions through the SQL queries:
1. What are the top-paying Data Analyst jobs?
2. What skills are required for the top-paying Data Analyst jobs?
3. What are the most in-demand skills for data analysis?
4. What are the top skills based on salary?
5. What are the optimal skills to learn (i.e. in high demand and high-paying)?

# Tools I Used

For this deep dive into the Data Analysis job market, several tools were used:

- **SQL:** The backbone of this analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** Database management and executing SQL queries.
- **Git & Github:** Essential for control version and sharing my SQL scripts and analysis, allowing for collaboration and project tracking.

# The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here is the approach to each question:

## 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average, yearly salary, and location, focusing on remote and Canadian 🇨🇦 jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Anywhere' OR job_location LIKE '%Canada%') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

Here's a breakdown of the top Data Analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying Data Analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries.
- **Job Title Variety:** There's a diversity in job titles, from Data Analyst to Director of Analytics, reflecting different specializations within data analytics.

## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing an insight into skills leading to high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        (job_location = 'Anywhere' OR job_location LIKE '%Canada%') AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
A breakdown of the most demanded skills for the Top 10 highest-paying Data Analyst jobs in 2023:

- **SQL** is leading with a count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is also highly sought after, with a count of 5.
- **Other skills** such as R, Pandas, and Excel show varying degrees of demand.

## 3. In-demand Skills for Data Analysis
This query helped to identify skills most frequently requested in job postings, focusing to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' \
    AND (job_location = 'Anywhere' OR job_location LIKE '%Canada%')
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

Here's a breakdown of the most demanded skills for Data Analysts in 2023:

- **SQL** and **Excel** remain fundamental.
- **Programming** and **Visualization Tools** like **Python, Tableau,** and **Power BI** are essential, pointing towards the importance of technical skills in data storytelling and decision support.

## 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paid.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND (job_location = 'Anywhere' OR job_location LIKE '%Canada%')
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

Here's a breakdown of the results for the top-paying skills for Data Analysts:

- **Big Data and Machine Learning Tools:** High-paying skills include PySpark, Databricks, Pandas, and Scikit-Learn, emphasizing demand for big data processing and machine learning expertise.

- **Database Management and Data Retrieval:** Skills like Elasticsearch, Couchbase, and PostgreSQL highlight the value of advanced data storage and querying abilities.

- **Collaboration and DevOps Knowledge:** Proficiency in tools like Bitbucket, GitLab, and Kubernetes reflects the importance of collaborative and automation skills in data analyst roles.

|Category|	Top-Paying Skills|	Example Salaries|
|--------|-------------------|------------------|
|Big Data and Machine Learning|	PySpark, Databricks, Pandas, Scikit-Learn|	$208,172, $138,189, $151,821, $125,781|
Database Management|	Elasticsearch, Couchbase, PostgreSQL|	$145,000, $160,515, $123,879|
|Collaboration and DevOps|	Bitbucket, GitLab, Kubernetes	|$189,155, $154,500, $132,500|

## 5. Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint the skills that are both in high demand and highly paid, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact   
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND (job_location = 'Anywhere' OR job_location LIKE '%Canada%')
GROUP BY
        skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
Here's a breakdown of the optimal skills for Data Analysts in 2023:

- **Cloud and Data Engineering Skills:** High-demand skills like Databricks ($138,189), Snowflake ($112,344), and AWS ($107,762) are among the top-paying, reflecting a strong need for cloud computing and data pipeline management expertise.

- **Programming and Data Analysis Tools:** Foundational tools such as Python ($100,899), R ($100,485), and Tableau ($99,035) are widely demanded and essential in data roles, showing steady salaries as they remain core to analytics work.

- **Collaborative and Workflow Management:** Skills like Confluence ($114,210), Jira ($104,708), and SSIS ($106,683) highlight the importance of collaboration and ETL tools, crucial for complex data projects in team-based environments.

# Conclusions

## Insights

From the analysis, several insights emerged:

- **Top-paying Data Analyst Jobs:** The highest-paying jobs for Data Analysis that allow remote work offer a wide range of salaries, with the highest-paid being at $650,000.
- **Skills for Top-Paying Jobs:** High-paying Data Analyst jobs require advanced proficiency in SQL.
- **Most In-demand Skills:** SQL is also the most demanded skill in the Data Analyst job market, making it essential.
- **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity are associated with high salaries, indicating a premium on niche expertise.
- **Optimal Skills for Job Market Value:** SQL leads in demand and offers a  high average salary.

## Closing Thoughts
This project helped me to practice my SQL skills and provided valuable insights into the Data Analysis job market. The findings serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field.