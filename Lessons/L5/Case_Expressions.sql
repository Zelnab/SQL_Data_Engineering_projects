SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg <25 THEN 'Low'
        WHEN salary_hour_avg <50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;

/*
┌─────────────────┬─────────────────┬─────────────────┐
│ job_title_short │ salary_hour_avg │ salary_category │
│     varchar     │     double      │     varchar     │
├─────────────────┼─────────────────┼─────────────────┤
│ Data Analyst    │            20.0 │ Low             │
│ Data Scientist  │            20.0 │ Low             │
│ Data Analyst    │            15.0 │ Low             │
│ Data Analyst    │           35.75 │ Medium          │
│ Data Analyst    │            36.0 │ Medium          │
│ Data Analyst    │            55.0 │ High            │
│ Data Engineer   │            64.5 │ High            │
│ Data Scientist  │            20.0 │ Low             │
│ Data Scientist  │            20.0 │ Low             │
│ Data Engineer   │            25.5 │ Medium          │
└─────────────────┴─────────────────┴─────────────────┘
*/
---- null value
SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN salary_hour_avg <25 THEN 'Low'
        WHEN salary_hour_avg <50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
LIMIT 10;

/*
┌─────────────────────┬─────────────────┬─────────────────┐
│   job_title_short   │ salary_hour_avg │ salary_category │
│       varchar       │     double      │     varchar     │
├─────────────────────┼─────────────────┼─────────────────┤
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Senior Data Analyst │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Senior Data Analyst │            NULL │ Missing         │
│ Business Analyst    │            NULL │ Missing         │
└─────────────────────┴─────────────────┴─────────────────┘
*/
------
--categorizing categorical values
--'Data Analyst'
--'Data Engineer'
--'Data Scientist'

SELECT 
job_title,
    CASE
        WHEN job_title like '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title like '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title like '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;

/* 
┌─────────────────────────────────────┬────────────────────┬───────────────────────────┐
│              job_title              │ job_title_category │      job_title_short      │
│               varchar               │      varchar       │          varchar          │
├─────────────────────────────────────┼────────────────────┼───────────────────────────┤
│ Data Engineer (m/w/d)               │ Data Engineer      │ Data Engineer             │
│ Data Analyst                        │ Data Analyst       │ Data Analyst              │
│ Junior Machine Learning Engineer    │ Other              │ Machine Learning Engineer │
│ Build your Data Analytics Portfolio │ Other              │ Data Analyst              │
│ Senior Data Platform Lead           │ Other              │ Senior Data Scientist     │
│ FP&A Analyst/Senior Analyst         │ Other              │ Senior Data Analyst       │
│ Data Analyst                        │ Data Analyst       │ Data Analyst              │
│ AI/ML Researcher                    │ Other              │ Machine Learning Engineer │
│ Data Quality Expert                 │ Other              │ Data Scientist            │
│ Data Scientist                      │ Data Scientist     │ Data Scientist            │
└─────────────────────────────────────┴────────────────────┴───────────────────────────┘
*/

--conditional Aggregation
--calculate Median Salaries for Different Buckets
--<$100k
-->=$100k

SELECT
    job_title_short,
    COUNT(*) total_postings,
    MEDIAN(
        CASE
            WHEN salary_year_avg <100000 THEN salary_year_avg
        END
    ) median_low_salary,
    MEDIAN(
        CASE
            WHEN salary_year_avg >100000 THEN salary_year_avg
        END
    ) median_high_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;

/*
┌───────────────────────────┬────────────────┬───────────────────┬────────────────────┐
│      job_title_short      │ total_postings │ median_low_salary │ median_high_salary │
│          varchar          │     int64      │      double       │       double       │
├───────────────────────────┼────────────────┼───────────────────┼────────────────────┤
│ Machine Learning Engineer │           1334 │           78261.5 │           166000.0 │
│ Senior Data Analyst       │           2603 │           87500.0 │           123800.0 │
│ Cloud Engineer            │            219 │           79200.0 │           136000.0 │
│ Senior Data Engineer      │           3283 │           87179.5 │           150000.0 │
│ Senior Data Scientist     │           3271 │           89100.0 │           157500.0 │
│ Data Engineer             │          10551 │           87500.0 │           142500.0 │
│ Data Analyst              │          13600 │           75000.0 │           118150.0 │
│ Software Engineer         │           1578 │           79200.0 │           174400.0 │
│ Data Scientist            │          12625 │           80000.0 │           143000.0 │
│ Business Analyst          │           1962 │           80000.0 │           125495.0 │
└───────────────────────────┴────────────────┴───────────────────┴────────────────────┘

*/

--conditional calculations
--compute a standardiezed salary using yearly salary and adjusted hourly salary (2080 H/Y)
--<75k 'low'
--75k-150k 'medium'
-->=150k 'high'

with salaries as(
SELECT 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    CASE
        WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
        WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg
    END AS standardiezed_salary
FROM job_postings_fact
--WHERE salary_year_avg IS NOT NULL or salary_hour_avg IS NOT NULL
) 
SELECT *,
    CASE 
        WHEN standardiezed_salary IS NULL THEN 'Missing'
        WHEN standardiezed_salary < 75000 THEN 'Low'
        WHEN standardiezed_salary < 150000 THEN 'Medium'
        ELSE 'High'
    END as salary_bucket
FROM salaries
LIMIT 10;

/*
┌──────────────────┬─────────────────┬─────────────────┬──────────────────────┬───────────────┐
│ job_title_short  │ salary_hour_avg │ salary_year_avg │ standardiezed_salary │ salary_bucket │
│     varchar      │     double      │     double      │        double        │    varchar    │
├──────────────────┼─────────────────┼─────────────────┼──────────────────────┼───────────────┤
│ Data Analyst     │            20.0 │            NULL │                 20.0 │ Low           │
│ Data Scientist   │            NULL │        110000.0 │             110000.0 │ Medium        │
│ Data Engineer    │            NULL │         65000.0 │              65000.0 │ Low           │
│ Business Analyst │            NULL │         90000.0 │              90000.0 │ Medium        │
│ Data Analyst     │            NULL │         55000.0 │              55000.0 │ Low           │
│ Data Scientist   │            20.0 │            NULL │                 20.0 │ Low           │
│ Data Scientist   │            NULL │        120531.0 │             120531.0 │ Medium        │
│ Data Engineer    │            NULL │        300000.0 │             300000.0 │ High          │
│ Data Analyst     │            NULL │         51000.0 │              51000.0 │ Low           │
│ Data Scientist   │            NULL │        133500.0 │             133500.0 │ Medium        │
└──────────────────┴─────────────────┴─────────────────┴──────────────────────┴───────────────┘
*/
