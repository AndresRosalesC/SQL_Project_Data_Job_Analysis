/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analysts
- Focus on roles with specified salaries, in Canada and remotely
- Why? It reveals how different skills impact salary levels for Data Analysts
    and helps identify the most financially rewarding skills for job seekers
*/

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

/*
Here's a breakdown of the results for top paying skills

- Big Data and Machine Learning Tools: High-paying skills include PySpark, Databricks, Pandas, and Scikit-Learn, emphasizing demand for big data processing and machine learning expertise.

- Database Management and Data Retrieval: Skills like Elasticsearch, Couchbase, and PostgreSQL highlight the value of advanced data storage and querying abilities.

- Collaboration and DevOps Knowledge: Proficiency in tools like Bitbucket, GitLab, and Kubernetes reflects the importance of collaborative and automation skills in data analyst roles.

  {
    "skills": "pyspark",
    "avg_salary": "208172"
  },
  {
    "skills": "bitbucket",
    "avg_salary": "189155"
  },
  {
    "skills": "watson",
    "avg_salary": "160515"
  },
  {
    "skills": "couchbase",
    "avg_salary": "160515"
  },
  {
    "skills": "datarobot",
    "avg_salary": "155486"
  },
  {
    "skills": "gitlab",
    "avg_salary": "154500"
  },
  {
    "skills": "swift",
    "avg_salary": "153750"
  },
  {
    "skills": "jupyter",
    "avg_salary": "152777"
  },
  {
    "skills": "pandas",
    "avg_salary": "151821"
  },
  {
    "skills": "golang",
    "avg_salary": "145000"
  },
  {
    "skills": "elasticsearch",
    "avg_salary": "145000"
  },
  {
    "skills": "numpy",
    "avg_salary": "143513"
  },
  {
    "skills": "databricks",
    "avg_salary": "138189"
  },
  {
    "skills": "linux",
    "avg_salary": "136508"
  },
  {
    "skills": "kubernetes",
    "avg_salary": "132500"
  },
  {
    "skills": "atlassian",
    "avg_salary": "131162"
  },
  {
    "skills": "twilio",
    "avg_salary": "127000"
  },
  {
    "skills": "airflow",
    "avg_salary": "126103"
  },
  {
    "skills": "scikit-learn",
    "avg_salary": "125781"
  },
  {
    "skills": "jenkins",
    "avg_salary": "125436"
  },
  {
    "skills": "notion",
    "avg_salary": "125000"
  },
  {
    "skills": "scala",
    "avg_salary": "124903"
  },
  {
    "skills": "postgresql",
    "avg_salary": "123879"
  },
  {
    "skills": "microstrategy",
    "avg_salary": "121619"
  },
  {
    "skills": "crystal",
    "avg_salary": "120100"
  }
]

*/