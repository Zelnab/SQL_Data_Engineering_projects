SELECT 
    job_title, 
    salary_year_avg * 0.8 avg, 
    salary_year_avg * 1.2 avg_salary, 
    job_work_from_home 
FROM job_postings_fact
where (job_title like '%Data Engineer%' or job_title like '%Data Analyst%') 
and job_work_from_home = True
and  salary_year_avg IS NOT NULL
LIMIT 10;
/*
 برای اینکه بفهمیم در هر کشور، میانگین حقوق چقدر است و چند آگهی ثبت شده است:
*/

 SELECT count (*) count_of_ad,job_location,  AVG(salary_year_avg) avg
 from job_postings_fact
 group by job_location
 having AVG(salary_year_avg)> 120000
 LIMIT 10;



SELECT count(jpf.job_title) total_job, cd.name from company_dim cd
join job_postings_fact jpf
on cd.company_id=jpf.company_id
group by cd.name
LIMIT 10;


SELECT * from job_postings_fact
where job_title not like '%Senior%'
and salary_year_avg between 100000 and 150000
LIMIT 10;


SELECT job_title , AVG (salary_year_avg) 
from job_postings_fact
group by job_title
having AVG (salary_year_avg) >120000
LIMIT 10;


SELECT CONCAT(job_id ,'-' , job_title)   
from job_postings_fact
LIMIT 10;

SELECT CONCAT(cast(job_id AS CHAR) ,'-' , job_title)   
from job_postings_fact
LIMIT 10;

