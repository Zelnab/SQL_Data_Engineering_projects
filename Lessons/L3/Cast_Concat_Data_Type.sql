SELECT 
    CONCAT(job_id ,'-' , job_title)   
from job_postings_fact
LIMIT 10;

/*
┌────────────────────────────────────────────────┐
│         concat(job_id, '-', job_title)         │
│                    varchar                     │
├────────────────────────────────────────────────┤
│ 4593-Data Analyst                              │
│ 4594-Data Analyst                              │
│ 4595-Data Analyst                              │
│ 4596-Senior Data Analyst / Platform Experience │
│ 4597-Data Analyst                              │
│ 4598-Jr. Data Analyst                          │
│ 4599-Data Analyst                              │
│ 4600-Loyalty Data Analyst III                  │
│ 4601-Senior data analyst                       │
│ 4602-Business Analyst - Taxonomy/Ontology      │
└────────────────────────────────────────────────┘
*/

SELECT 
    CONCAT(cast(job_id AS CHAR) ,'-' , job_title)   
from job_postings_fact
LIMIT 10;

/*
│ concat(CAST(job_id AS VARCHAR(1)), '-', job_title) │
│                      varchar                       │
├────────────────────────────────────────────────────┤
│ 4593-Data Analyst                                  │
│ 4594-Data Analyst                                  │
│ 4595-Data Analyst                                  │
│ 4596-Senior Data Analyst / Platform Experience     │
│ 4597-Data Analyst                                  │
│ 4598-Jr. Data Analyst                              │
│ 4599-Data Analyst                                  │
│ 4600-Loyalty Data Analyst III                      │
│ 4601-Senior data analyst                           │
│ 4602-Business Analyst - Taxonomy/Ontology          │
└────────────────────────────────────────────────────┘
*/

SELECT CAST(123 as VARCHAR);
SELECT CAST('123' as INTEGER);


SELECT 
    CAST(job_id AS VARCHAR) || CAST(company_id AS VARCHAR)AS id,
    --CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR)AS id,
    CAST(job_work_from_home AS INTEGER)as work_from_home, -- from bool to numeric
    CAST(job_posted_date AS DATE)as job_posted_date ,-- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10,0))as salary_year_avg-- from double to no decimal places
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

/*
┌──────────┬────────────────┬─────────────────┬─────────────────┐
│    id    │ work_from_home │ job_posted_date │ salary_year_avg │
│ varchar  │     int32      │      date       │  decimal(10,0)  │
├──────────┼────────────────┼─────────────────┼─────────────────┤
│ 46514651 │              0 │ 2023-01-01      │          110000 │
│ 46994699 │              0 │ 2023-01-01      │           65000 │
│ 48044804 │              1 │ 2023-01-01      │           90000 │
│ 48104810 │              0 │ 2023-01-01      │           55000 │
│ 48334833 │              0 │ 2023-01-01      │          120531 │
│ 48464846 │              0 │ 2023-01-01      │          300000 │
│ 50895089 │              0 │ 2023-01-01      │           51000 │
│ 51235123 │              0 │ 2023-01-01      │          133500 │
│ 53215321 │              0 │ 2023-01-01      │           77500 │
│ 53255321 │              0 │ 2023-01-01      │          125000 │
└──────────┴────────────────┴─────────────────┴─────────────────┘
*/

SELECT 
    job_id :: VARCHAR || '-' || company_id :: VARCHAR AS id,
    job_work_from_home :: INTEGER as work_from_home, -- from bool to numeric
    job_posted_date :: DATE as job_posted_date ,-- from timestamp to date only
    salary_year_avg :: DECIMAL(10,0) as salary_year_avg-- from double to no decimal places
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

/*
┌───────────┬────────────────┬─────────────────┬─────────────────┐
│    id     │ work_from_home │ job_posted_date │ salary_year_avg │
│  varchar  │     int32      │      date       │  decimal(10,0)  │
├───────────┼────────────────┼─────────────────┼─────────────────┤
│ 4651-4651 │              0 │ 2023-01-01      │          110000 │
│ 4699-4699 │              0 │ 2023-01-01      │           65000 │
│ 4804-4804 │              1 │ 2023-01-01      │           90000 │
│ 4810-4810 │              0 │ 2023-01-01      │           55000 │
│ 4833-4833 │              0 │ 2023-01-01      │          120531 │
│ 4846-4846 │              0 │ 2023-01-01      │          300000 │
│ 5089-5089 │              0 │ 2023-01-01      │           51000 │
│ 5123-5123 │              0 │ 2023-01-01      │          133500 │
│ 5321-5321 │              0 │ 2023-01-01      │           77500 │
│ 5325-5321 │              0 │ 2023-01-01      │          125000 │
└───────────┴────────────────┴─────────────────┴─────────────────┘
*/
