--subquery
SELECT * 
FROM 
(SELECT * 
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)AS valid_salaries LIMIT 10;

--1:subquery in 'SELECT' 
--show each job's salary next to the overall market median:
SELECT 
    job_title_short,
    salary_year_avg,
(SELECT MEDIAN(salary_year_avg)
FROM job_postings_fact
)AS MEDIAN_salaries 
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;
/*
┌──────────────────┬─────────────────┬─────────────────┐
│ job_title_short  │ salary_year_avg │ MEDIAN_salaries │
│     varchar      │     double      │     double      │
├──────────────────┼─────────────────┼─────────────────┤
│ Data Scientist   │        110000.0 │        116950.0 │
│ Data Engineer    │         65000.0 │        116950.0 │
│ Business Analyst │         90000.0 │        116950.0 │
│ Data Analyst     │         55000.0 │        116950.0 │
│ Data Scientist   │        120531.0 │        116950.0 │
│ Data Engineer    │        300000.0 │        116950.0 │
│ Data Analyst     │         51000.0 │        116950.0 │
│ Data Scientist   │        133500.0 │        116950.0 │
│ Data Analyst     │         77500.0 │        116950.0 │
│ Data Scientist   │        125000.0 │        116950.0 │
└──────────────────┴─────────────────┴─────────────────┘
*/

--2:subquery in 'FROM' 
--stage only jobs that are remote befor aggregating to determine the remote median salary per job:

SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) median_salaries ,
(SELECT MEDIAN(salary_year_avg)
FROM job_postings_fact
WHERE job_work_from_home = TRUE
)AS market_remote_median_salaries 
FROM (
    SELECT 
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_work_from_home = TRUE
)AS clean_jobs
GROUP BY job_title_short
LIMIT 10;


/*
┌───────────────────────────┬─────────────────┬───────────────────────────────┐
│      job_title_short      │ median_salaries │ market_remote_median_salaries │
│          varchar          │     double      │            double             │
├───────────────────────────┼─────────────────┼───────────────────────────────┤
│ Senior Data Analyst       │        105000.0 │                      130000.0 │
│ Machine Learning Engineer │        138433.5 │                      130000.0 │
│ Cloud Engineer            │        132000.0 │                      130000.0 │
│ Senior Data Engineer      │        145000.0 │                      130000.0 │
│ Data Analyst              │         87500.0 │                      130000.0 │
│ Software Engineer         │        180000.0 │                      130000.0 │
│ Senior Data Scientist     │        160000.0 │                      130000.0 │
│ Data Engineer             │        135000.0 │                      130000.0 │
│ Data Scientist            │        132500.0 │                      130000.0 │
│ Business Analyst          │         90000.0 │                      130000.0 │
└───────────────────────────┴─────────────────┴───────────────────────────────┘
*/
--3: subquery in HAVING -- keep only job title whose median salary is above the overall median:

SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) median_salaries ,
(SELECT MEDIAN(salary_year_avg)
FROM job_postings_fact
WHERE job_work_from_home = TRUE
)AS market_remote_median_salaries 
FROM (
    SELECT 
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_work_from_home = TRUE
)AS clean_jobs
GROUP BY job_title_short
HAVING  MEDIAN(salary_year_avg)> (
    SELECT  MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home=TRUE
)
LIMIT 10;

/*
┌───────────────────────────┬─────────────────┬───────────────────────────────┐
│      job_title_short      │ median_salaries │ market_remote_median_salaries │
│          varchar          │     double      │            double             │
├───────────────────────────┼─────────────────┼───────────────────────────────┤
│ Machine Learning Engineer │        138433.5 │                      130000.0 │
│ Cloud Engineer            │        132000.0 │                      130000.0 │
│ Data Engineer             │        135000.0 │                      130000.0 │
│ Software Engineer         │        180000.0 │                      130000.0 │
│ Senior Data Engineer      │        145000.0 │                      130000.0 │
│ Senior Data Scientist     │        160000.0 │                      130000.0 │
│ Data Scientist            │        132500.0 │                      130000.0 │
└───────────────────────────┴─────────────────┴───────────────────────────────┘
*/




--CTE
WITH valid_salaries AS 
(SELECT * 
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
SELECT * FROM valid_salaries;


--compare how much more (or less) remot roles pay compared to onsite roles for each job title.
--Use a CTE to calculate the median salary by title and work arrangment, then compare those medians.

WITH title_median as(
SELECT 
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg):: INT as median_salaries
FROM job_postings_fact
WHERE job_country='United States'
GROUP BY  
    job_title_short,
    job_work_from_home
)
SELECT 
    r.job_title_short,
    r.median_salaries as remot_median_salary,
    o.median_salaries as onsite_median_salary,
    (r.median_salaries-o.median_salaries)as remot_premium
FROM title_median as r
join title_median as o 
on r.job_title_short=o.job_title_short
WHERE r.job_work_from_home=TRUE
    and o.job_work_from_home=FALSE
ORDER BY remot_premium DESC;

/*
┌───────────────────────────┬─────────────────────┬──────────────────────┬───────────────┐
│      job_title_short      │ remot_median_salary │ onsite_median_salary │ remot_premium │
│          varchar          │        int32        │        int32         │     int32     │
├───────────────────────────┼─────────────────────┼──────────────────────┼───────────────┤
│ Machine Learning Engineer │              168500 │               151250 │         17250 │
│ Data Scientist            │              135000 │               127266 │          7734 │
│ Data Engineer             │              135000 │               130000 │          5000 │
│ Senior Data Scientist     │              160000 │               157500 │          2500 │
│ Data Analyst              │               90000 │                90000 │             0 │
│ Senior Data Analyst       │              107913 │               110400 │         -2487 │
│ Senior Data Engineer      │              145000 │               150000 │         -5000 │
│ Business Analyst          │               90000 │                95160 │         -5160 │
│ Software Engineer         │              122500 │               150000 │        -27500 │
│ Cloud Engineer            │               51250 │               135000 │        -83750 │
└───────────────────────────┴─────────────────────┴──────────────────────┴───────────────┘
*/

