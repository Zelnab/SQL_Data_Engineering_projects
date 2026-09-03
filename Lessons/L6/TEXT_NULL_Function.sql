
WITH title_lower AS(
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)
SELECT 
job_title,
    CASE
        WHEN job_title_clean like '%data%' AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean like '%data%' AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean like '%data%' AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 10;
/*
┌───────────────────────────────────────────────────┬────────────────────┐
│                     job_title                     │ job_title_category │
│                      varchar                      │      varchar       │
├───────────────────────────────────────────────────┼────────────────────┤
│ Data Scientist Advisor de Pricing                 │ Data Scientist     │
│ S411 | Data Engineer Talent                       │ Data Engineer      │
│ C++ Senior Engineer                               │ Other              │
│ Analytics Engineer                                │ Other              │
│ Senior Platform Engineer - Hybrid                 │ Other              │
│ Data Scientist                                    │ Data Scientist     │
│ Sr. Data Analyst                                  │ Data Analyst       │
│ Data Scientist II - AI/ML                         │ Data Scientist     │
│ Senior Data Scientist - AI Services and Platforms │ Data Scientist     │
│ Healthcare Data Analyst Nurse                     │ Data Analyst       │
└───────────────────────────────────────────────────┴────────────────────┘
*/


SELECT 
   MEDIAN (NULLIF(salary_year_avg,0)),
   MEDIAN (NULLIF(salary_hour_avg,0))
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;

/*
┌──────────────────────────────────────┬──────────────────────────────────────┐
│ median("nullif"(salary_year_avg, 0)) │ median("nullif"(salary_hour_avg, 0)) │
│                double                │                double                │
├──────────────────────────────────────┼──────────────────────────────────────┤
│                             116950.0 │                   46.779998779296875 │
└──────────────────────────────────────┴──────────────────────────────────────┘

*/


SELECT 
   salary_year_avg,
   salary_hour_avg,
   COALESCE(salary_year_avg,salary_hour_avg*2080)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;

/*
┌─────────────────┬─────────────────┬─────────────────────────────────────────────────────┐
│ salary_year_avg │ salary_hour_avg │ COALESCE(salary_year_avg, (salary_hour_avg * 2080)) │
│     double      │     double      │                       double                        │
├─────────────────┼─────────────────┼─────────────────────────────────────────────────────┤
│            NULL │            20.0 │                                             41600.0 │
│        110000.0 │            NULL │                                            110000.0 │
│         65000.0 │            NULL │                                             65000.0 │
│         90000.0 │            NULL │                                             90000.0 │
│         55000.0 │            NULL │                                             55000.0 │
│            NULL │            20.0 │                                             41600.0 │
│        120531.0 │            NULL │                                            120531.0 │
│        300000.0 │            NULL │                                            300000.0 │
│         51000.0 │            NULL │                                             51000.0 │
│        133500.0 │            NULL │                                            133500.0 │
└─────────────────┴─────────────────┴─────────────────────────────────────────────────────┘
*/


SELECT 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    COALESCE(salary_year_avg,salary_hour_avg*2080) standardized_salary,
    CASE 
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2080) < 75000 THEN 'Low'
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2080) < 150000 THEN 'Medium'
        ELSE 'High'
    END as salary_bucket
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;

/*
┌───────────────────────┬────────────────────┬───┬─────────────────────┬───────────────┐
│    job_title_short    │  salary_hour_avg   │ … │ standardized_salary │ salary_bucket │
│        varchar        │       double       │ … │       double        │    varchar    │
├───────────────────────┼────────────────────┼───┼─────────────────────┼───────────────┤
│ Data Analyst          │               NULL │ … │                NULL │ Missing       │
│ Business Analyst      │               NULL │ … │                NULL │ Missing       │
│ Data Scientist        │               NULL │ … │                NULL │ Missing       │
│ Senior Data Engineer  │               NULL │ … │            150000.0 │ High          │
│ Senior Data Scientist │               NULL │ … │                NULL │ Missing       │
│ Business Analyst      │               NULL │ … │                NULL │ Missing       │
│ Data Analyst          │               NULL │ … │                NULL │ Missing       │
│ Senior Data Analyst   │ 24.334999084472656 │ … │  50616.798095703125 │ Low           │
│ Data Engineer         │               NULL │ … │                NULL │ Missing       │
│ Data Analyst          │               NULL │ … │                NULL │ Missing       │
└───────────────────────┴────────────────────┴───┴─────────────────────┴───────────────┘
*/
