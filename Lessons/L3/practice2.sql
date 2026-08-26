SELECT 
    job_location,
    count(job_title)total_job, 
    AVG(salary_year_avg) avg_salary 
FROM job_postings_fact
group by job_location
having 
    count(job_title)>100 
    and AVG(salary_year_avg) between 50000 and 100000
order by total_job
limit 10;


SELECT 
    job_id, 
    job_title,
    job_location, 
    salary_year_avg, 
    job_work_from_home 
FROM job_postings_fact
where job_title not like '%Senior%'
or (LOWER(job_title) like '%remot%'
or job_location ='London')
limit 10;


SELECT 
    job_id, 
    job_title,
    job_location, 
    salary_year_avg, 
    job_work_from_home 
FROM job_postings_fact
where job_id % 5 =0
limit 10;


SELECT 
    job_id, 
    job_title,
    job_location, 
    salary_year_avg,
    salary_year_avg / 280 as day_salary, 
    job_work_from_home 
    FROM job_postings_fact
order by day_salary desc
limit 10;


/*information_schema*/

SELECT column_name,data_type 
FROM information_schema.columns 
where table_name = 'company_dim'; 

SELECT * 
FROM information_schema.tables 
WHERE table_schema = 'main';


CREATE SCHEMA analysis;
CREATE TABLE IF NOT EXISTS analysis.top_paying_jobs (
    job_id INTEGER PRIMARY KEY
);

select * 
from  information_schema.constraint_column_usage
where constraint_type='PRIMARY KEY';

select * 
from information_schema.constraint_column_usage
where constraint_type='FOREIGN KEY'


CREATE TABLE company_locations (
    company_id INTEGER,
    FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
);

