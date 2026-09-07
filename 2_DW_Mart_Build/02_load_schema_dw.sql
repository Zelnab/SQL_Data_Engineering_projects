--step 2: DW - Load data from csv files into tables

SELECT '=== loading company_dim table ===' as info;
-- Load dimension tables first (no FK dependencies)
INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true);


SELECT '=== loading skills_dim table ===' as info;

INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true)
WHERE skills IS NOT NULL;


SELECT '=== loading job_postings_fact table ===' as info;
-- Load fact table second (FK references company_dim - must load after dimensions)
INSERT INTO job_postings_fact (
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT 
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', 
    AUTO_DETECT=true,
    HEADER=true);


SELECT '=== loading skills_job_dim table ===' as info;
-- Load bridge table last (FKs reference skills_dim and job_postings_fact)
INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true);


SELECT 'Company Dim' AS table_name, count(*) AS record_count FROM company_dim
UNION ALL 
SELECT 'Skills Dim', count(*) FROM skills_dim
UNION ALL 
SELECT 'Job Postings Fact', count(*) FROM job_postings_fact
UNION ALL 
SELECT 'Skills Job Dim', count(*) FROM skills_job_dim;

SELECT '=== company dimension sample ===' as info;
SELECT * from company_dim LIMIT 5;
SELECT '===  skills dim sample ===' as info;
SELECT * from skills_dim LIMIT 5;
SELECT '=== job postings fact sample ===' as info;
SELECT * from SELECT 'Job Postings Fact', count(*) FROM job_postings_fact
 LIMIT 5;
SELECT '===skills job dim sample ===' as info;
SELECT * from skills_job_dim LIMIT 5;