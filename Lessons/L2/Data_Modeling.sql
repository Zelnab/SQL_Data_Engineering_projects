SELECT 
    *
FROM
    company_dim
LIMIT 10;


SELECT  
    job_id,
    company_id,
    job_title_short,    
    salary_year_avg
FROM 
    job_postings_fact
LIMIT 10;