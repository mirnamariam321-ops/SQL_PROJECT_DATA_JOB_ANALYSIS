# Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/).
# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from my [SQL Course](https://github.com/Mirna-mariam/SQL_PROJECT_DATA_JOB_ANALYSIS.git). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools i used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- SQL: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- PostgreSQL: The chosen database management system, ideal for handling the job posting data.
- Visual Studio Code: My go-to for database management and executing SQL queries.
- Git & GitHub: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
``` sql
SELECT
       job_id,
       job_title,
       job_location,
       job_schedule_type,
       salary_year_avg,
       job_posted_date,
       name AS company_name /* to get comapny name*/
 FROM 
       job_postings_fact
 LEFT JOIN   company_dim ON job_postings_fact.company_id = company_dim.company_id  
 WHERE    
       job_title_short='Data Analyst'  AND 
       job_location = 'Anywhere'  AND   
       salary_year_avg IS NOT NULL
 ORDER BY 
      salary_year_avg DESC
 LIMIT 10;
 ```
 Here's the breakdown of the top data analyst jobs:

- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.

- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.

- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS(
SELECT
       job_id,
       job_title,
       salary_year_avg,
       name AS company_name /* to get comapny name*/
 FROM 
       job_postings_fact
 LEFT JOIN   
      company_dim ON job_postings_fact.company_id = company_dim.company_id  
 WHERE    
       job_title_short='Data Analyst'  AND 
       job_location = 'Anywhere'  AND   
       salary_year_avg IS NOT NULL
 ORDER BY 
      salary_year_avg DESC
 LIMIT 10
)
SELECT  top_paying_jobs.* ,    /* to take all the columns of this table only */
        skills AS skill_name
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
      salary_year_avg DESC
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs :

- SQL is leading with a bold count of 8.
- Python follows closely with a bold count of 7.
- Tableau is also highly sought after, with a bold count of 6. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.
### 3. In-Demand Skills for Data Analysts
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills | Demand Count |
|--------|--------------|
| SQL | 92628 |
| Excel | 67031 |
| Python | 57326 |
| Tableau | 46554 |
| Power BI | 39468 |

*Table of the demand for the top five most in-demand skills for data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed wich skills are the highest paying.
```sql
SELECT 
        skills,
        ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
       job_title_short ='Data Analyst' AND
       salary_year_avg IS NOT NULL  /* so that the query will be faster */
GROUP BY 
        skills
ORDER BY 
        avg_salary DESC
LIMIT 25
```
Here's a breakdown of the results for top paying skills for Data Analysts:

- High Demand for Big Data & ML Skills: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- Software Development & Deployment Proficiency: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- Cloud Computing Expertise: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environment, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS (
SELECT 
        
       skills_dim.skill_id,
       skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
       job_title_short ='Data Analyst' AND
       salary_year_avg IS NOT NULL AND
       job_work_from_home = TRUE
GROUP BY 
       skills_dim.skill_id

) ,

average_salary AS ( 
SELECT 
        
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
       job_title_short ='Data Analyst' AND
       salary_year_avg IS NOT NULL  /* so that the query will be faster */ AND
       job_work_from_home = TRUE
GROUP BY 
        skills_job_dim.skill_id

)

SELECT
       skills_demand.skill_id,
       skills_demand.skills,
       demand_count,
       avg_salary
FROM
       skills_demand
INNER JOIN 
       average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY 
       demand_count DESC,
       avg_salary DESC
       
LIMIT 25 
```
Here is the breakdown for the most *OPTIMAL* skills for Data Analysts - combining security + money:

## 1. The Foundation Skills - You MUST have these
Highest demand, non-negotiable for getting a job.

- *SQL* - 398 demand, $97,237 - The #1 skill. Still the king.
- *Excel* - 256 demand, $87,288 - Lowest salary of the top, but required for 90% of jobs.
- *Python* - 236 demand, $101,397 - *BEST BALANCE*. High demand + 6-figure salary. The most optimal skill overall.
- *Tableau* - 230 demand, $99,287 - Best visualization tool for employability.

> *Strategy:* If you only learn 3: SQL + Python + Tableau

## 2. The Sweet Spot - High Demand + High Salary
These are the most optimal for career growth. Good demand (20-150) and salary > $100k
Skill | Demand | Avg Salary | Verdict
**Python** | 236 | $101,397 | #1 Optimal
**R** | 148 | $100,498 | Great for stats roles
**Looker** | 49 | $103,795 | Underrated, high pay
**Oracle** | 37 | $104,533 | Enterprise high payer
**Snowflake** | 37 | $112,947 | **Top Strategic Skill**
**Azure** | 34 | $111,225 | Cloud = Money
**AWS** | 32 | $108,317 | Cloud = Money
**Go** | 27 | $115,319 | Very high pay for good demand
**Hadoop** | 22 | $113,192 | Big Data premium
*Top Pick for Salary Boost:* Learn *Snowflake + Azure/AWS*. Demand is 30+ and salary jumps $10k-$15k over SQL.

## 3. The Salary Rockets - Ultra High Pay, Low Demand
Demand 1-10, but salaries $125k - $208k. These are what make you a Top 1% earner. Companies pay a premium because few analysts have them.

- *PySpark* - $208,172 (demand 2) - Highest paying skill in your list
- *Bitbucket* - $189,154 (demand 2)
- *GitLab* - $154,500 (demand 3)
- *Jupyter* - $152,776 (demand 3)
- *Pandas* - $151,821 (demand 9) - *Best in this group*, decent demand
- *Numpy* - $143,512 (demand 5)
- *Databricks* - $141,906 (demand 10) - *Most achievable high-payer*
- *Atlassian* - $131,161 (demand 5)

> These reflect the insight from your screenshot: *Big Data & ML + Software Deployment skills = Top Pay*. A normal analyst knows SQL. A $150k+ analyst knows PySpark, GitLab, Airflow, Databricks.

## Final Recommendation - What to Learn in Order:

*For a Job NOW:* SQL > Excel > Python > Tableau

*For $100k+ ASAP:* Add *Snowflake, Looker, Azure/AWS, R*

*For $130k+ and Top Paying Roles:* Add *Databricks + Pandas/Numpy + PySpark + GitLab / Airflow / Kubernetes*

If you want the single most optimal formula:
*Python (101k) + Snowflake (112k) + Azure (111k) + Databricks (141k)* = You cover High Demand, Cloud, and Big Data. That's the exact crossover that commands top salaries.


# What i learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- ** Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- ** Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG () into my data-summarizing sidekicks.
- ** Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
# Conclusions
### Insights
1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
