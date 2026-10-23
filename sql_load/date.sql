SELECT
   job_title AS job_title,
   job_location AS location,
   job_posted_date ::Date AS date
 FROM job_postings_fact;

SELECT job_title AS job_title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM job_postings_fact
LIMIT 5;


CREATE TABLE january_jobs AS
SELECT* 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) =1;

CREATE TABLE february_jobs AS
SELECT* 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) =2;


CREATE TABLE march_jobs AS
SELECT* 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) =3;

SELECT job_posted_date
from march_jobs;
--subquery
SELECT * 
FROM( 
    SELECT* 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) =1
  ) AS  january_jobs;
  --CTEs 
  WITH january_jobs AS( --CTE definition starts here

 SELECT* 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) =1
  )  --CTE definition ends here
  SELECT* 
  FROM january_jobs;

  --another example on subqueries

  SELECT name as company_name
  FROM company_dim
  WHERE company_id IN(
    SELECT company_id
  FROM job_postings_fact
  WHERE job_no_degree_mention = true
  )