SELECT 
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (PARTITION BY job_title_short,company_id) avg_partition
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 10;
/*
┌─────────┬─────────────────────┬────────────┬───────────────────┬────────────────────┐
│ job_id  │   job_title_short   │ company_id │  salary_hour_avg  │   avg_partition    │
│  int32  │       varchar       │   int32    │      double       │       double       │
├─────────┼─────────────────────┼────────────┼───────────────────┼────────────────────┤
│  357531 │ Data Analyst        │      24262 │              36.0 │ 45.464285714285715 │
│ 1059424 │ Business Analyst    │     121989 │  35.7400016784668 │   35.7400016784668 │
│  337716 │ Data Scientist      │     192669 │              18.0 │               18.0 │
│  916156 │ Data Engineer       │     916156 │              92.5 │               92.5 │
│  852498 │ Data Scientist      │       6150 │             200.0 │ 145.77272727272728 │
│  499893 │ Data Scientist      │      11756 │ 47.76000213623047 │  47.76000213623047 │
│ 1178605 │ Data Analyst        │      12562 │              15.0 │               15.0 │
│  301273 │ Data Engineer       │     301273 │              73.0 │               73.0 │
│  873642 │ Data Analyst        │     178898 │              61.5 │              39.25 │
│  229915 │ Senior Data Analyst │     191581 │              60.0 │               60.0 │
└─────────┴─────────────────────┴────────────┴───────────────────┴────────────────────┘
*/

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (ORDER BY salary_hour_avg desc) rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
   salary_hour_avg desc
LIMIT 10;

/* 
┌─────────┬───────────────────────────┬─────────────────┬────────────────────┐
│ job_id  │      job_title_short      │ salary_hour_avg │ rank_hourly_salary │
│  int32  │          varchar          │     double      │       int64        │
├─────────┼───────────────────────────┼─────────────────┼────────────────────┤
│  256566 │ Data Analyst              │           391.0 │                  1 │
│ 1004296 │ Data Scientist            │           250.0 │                  2 │
│  110897 │ Data Analyst              │           242.5 │                  3 │
│  646328 │ Data Scientist            │           237.5 │                  4 │
│  210821 │ Data Scientist            │           225.0 │                  5 │
│ 1203880 │ Data Engineer             │           221.0 │                  6 │
│ 1056728 │ Machine Learning Engineer │           220.0 │                  7 │
│  193693 │ Data Analyst              │           210.0 │                  8 │
│  452720 │ Data Analyst              │           200.0 │                  9 │
│  833111 │ Data Scientist            │           200.0 │                  9 │
└─────────┴───────────────────────────┴─────────────────┴────────────────────┘
*/


SELECT 
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) running_avg_hourly_by_title
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
   job_title_short,
   job_posted_date
LIMIT 10;

/* 
┌─────────────────────┬──────────────────┬───────────────────┬─────────────────────────────┐
│   job_posted_date   │ job_title_short  │  salary_hour_avg  │ running_avg_hourly_by_title │
│      timestamp      │     varchar      │      double       │           double            │
├─────────────────────┼──────────────────┼───────────────────┼─────────────────────────────┤
│ 2023-01-04 22:57:02 │ Business Analyst │              17.0 │                        17.0 │
│ 2023-01-04 23:44:05 │ Business Analyst │              20.0 │                        18.5 │
│ 2023-01-05 21:02:18 │ Business Analyst │              35.0 │                        24.0 │
│ 2023-01-06 19:02:18 │ Business Analyst │              26.0 │                        24.5 │
│ 2023-01-06 20:03:13 │ Business Analyst │              20.0 │                        23.6 │
│ 2023-01-09 22:02:50 │ Business Analyst │              30.0 │          24.666666666666668 │
│ 2023-01-10 23:19:18 │ Business Analyst │              30.0 │          25.428571428571427 │
│ 2023-01-12 17:01:24 │ Business Analyst │              70.0 │                        31.0 │
│ 2023-01-13 17:04:10 │ Business Analyst │ 25.98500061035156 │           30.44277784559462 │
│ 2023-01-15 19:00:18 │ Business Analyst │              27.0 │          30.098500061035157 │
└─────────────────────┴──────────────────┴───────────────────┴─────────────────────────────┘
  10 rows                                                                        4 columns

*/


SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER (ORDER BY salary_hour_avg desc) rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
   salary_hour_avg desc
LIMIT 200;


SELECT *,
    ROW_NUMBER()OVER(
        ORDER BY job_posted_date
    )
FROM
    job_postings_fact
ORDER BY 
    job_posted_date
LIMIT 20;


SELECT 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg)OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    )as next_posting_salary,
    salary_year_avg - LAG(salary_year_avg)OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    )as salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY 
    company_id,
    job_posted_date
LIMIT 10;

/*

┌────────┬────────────┬──────────────────────────┬───┬─────────────────────┬───────────────┐
│ job_id │ company_id │        job_title         │ … │ next_posting_salary │ salary_change │
│ int32  │   int32    │         varchar          │ … │       double        │    double     │
├────────┼────────────┼──────────────────────────┼───┼─────────────────────┼───────────────┤
│ 842003 │       4593 │ Data Scientist           │ … │            150000.0 │          NULL │
│ 995381 │       4593 │ Lead Data Engineer       │ … │                NULL │       75000.0 │
│ 128388 │       4594 │ Data Scientist           │ … │            112450.0 │          NULL │
│ 134272 │       4594 │ AI/ML Health Data Scien… │ … │             90000.0 │       22450.0 │
│ 143916 │       4594 │ Data Scientist           │ … │             90000.0 │      -22450.0 │
│ 159423 │       4594 │ Data Scientist - Analyst │ … │             90000.0 │           0.0 │
│ 164436 │       4594 │ Data Scientist - Senior… │ … │            115000.0 │           0.0 │
│ 167525 │       4594 │ AI/ML Health Data Scien… │ … │            129050.0 │       25000.0 │
│ 179599 │       4594 │ Data Analyst - Business… │ … │            115000.0 │       14050.0 │
│ 235865 │       4594 │ Cleared Data Scientist   │ … │             90000.0 │      -14050.0 │
└────────┴────────────┴──────────────────────────┴───┴─────────────────────┴───────────────┘

*/

SELECT 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg)OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    )as lag_salary
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY 
    company_id,
    job_posted_date
LIMIT 10;

/*
┌────────┬────────────┬───┬─────────────────────┬─────────────────┬────────────┐
│ job_id │ company_id │ … │   job_posted_date   │ salary_year_avg │ lag_salary │
│ int32  │   int32    │ … │      timestamp      │     double      │   double   │
├────────┼────────────┼───┼─────────────────────┼─────────────────┼────────────┤
│ 842003 │       4593 │ … │ 2024-01-30 14:28:11 │         75000.0 │       NULL │
│ 995381 │       4593 │ … │ 2024-05-02 16:08:57 │        150000.0 │    75000.0 │
│ 128388 │       4594 │ … │ 2023-02-14 06:02:22 │         90000.0 │       NULL │
│ 134272 │       4594 │ … │ 2023-02-16 11:06:48 │        112450.0 │    90000.0 │
│ 143916 │       4594 │ … │ 2023-02-21 07:23:56 │         90000.0 │   112450.0 │
│ 159423 │       4594 │ … │ 2023-02-28 10:52:05 │         90000.0 │    90000.0 │
│ 164436 │       4594 │ … │ 2023-03-02 09:49:47 │         90000.0 │    90000.0 │
│ 167525 │       4594 │ … │ 2023-03-03 11:03:16 │        115000.0 │    90000.0 │
│ 179599 │       4594 │ … │ 2023-03-09 09:00:18 │        129050.0 │   115000.0 │
│ 235865 │       4594 │ … │ 2023-04-06 09:57:40 │        115000.0 │   129050.0 │
└────────┴────────────┴───┴─────────────────────┴─────────────────┴────────────┘
*/
