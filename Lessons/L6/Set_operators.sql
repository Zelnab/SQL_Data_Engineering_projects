CREATE TEMP TABLE jobs_2023 as
SELECT * exclude (job_id,job_posted_date)
FROM job_postings_fact
WHERE EXTRACT (YEAR FROM job_posted_date)=2023;

CREATE TEMP TABLE jobs_2024 as
SELECT * exclude (job_id,job_posted_date)
FROM job_postings_fact
WHERE EXTRACT (YEAR FROM job_posted_date)=2024;

SELECT * FROM jobs_2023;
SELECT * FROM jobs_2024;


SELECT 
    'jobs_2023' AS table_name,
    COUNT(*)
FROM jobs_2023
UNION
SELECT 
    'jobs_2024' AS table_name,
    COUNT(*)
FROM jobs_2024;

/*
┌────────────┬──────────────┐
│ table_name │ count_star() │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ jobs_2023  │       787356 │
│ jobs_2024  │       483959 │
└────────────┴──────────────┘
*/


SELECT *
FROM jobs_2023
UNION ALL
SELECT  *
FROM jobs_2024;




SELECT  *
FROM jobs_2023
EXCEPT
SELECT  *
FROM jobs_2024;





SELECT  *
FROM jobs_2023
EXCEPT ALL
SELECT  *
FROM jobs_2024;




SELECT  *
FROM jobs_2023
INTERSECT
SELECT  *
FROM jobs_2024;



SELECT  *
FROM jobs_2023
INTERSECT ALL
SELECT  *
FROM jobs_2024;

