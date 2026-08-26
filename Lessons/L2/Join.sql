/* LEFT JOIN */
SELECT 
    *
FROM
    job_postings_fact jpf
LEFT JOIN  
    company_dim cd 
on  jpf.company_id= cd.company_id
WHERE   job_title_short  ='Data Engineer'
LIMIT 10;

/* RIGHT JOIN */
SELECT 
    *
FROM
    job_postings_fact jpf
RIGHT JOIN  
    company_dim cd 
on  jpf.company_id= cd.company_id;
LIMIT 10;

SELECT 
    COUNT(*)
FROM
    job_postings_fact jpf
RIGHT JOIN  
    company_dim cd 
on  jpf.company_id= cd.company_id;


/* INNER JOIN */
SELECT 
    COUNT(*)
FROM
    job_postings_fact jpf
INNER JOIN  
    company_dim cd 
on  jpf.company_id= cd.company_id;

SELECT 
    COUNT(*)
FROM
    job_postings_fact jpf
JOIN  
    company_dim cd 
on  jpf.company_id= cd.company_id;


/* FULL OUTER JOIN */
SELECT 
    COUNT(*)
FROM
    job_postings_fact jpf
FULL JOIN  
    company_dim cd 
on  jpf.company_id= cd.company_id;

/*-----------------------------------*/
SELECT * FROM FROM job_postings_fact limit 1
SELECT * FROM skills_job_dim limit 1;
SELECT * FROM skills_dim limit 1;

SELECT 
    jpf.job_id, 
    jpf.job_title_short , 
    sjd.skill_id ,
    sd.skills,
    sd.type

FROM 
    job_postings_fact jpf
JOIN 
    skills_job_dim sjd
ON  jpf.job_id= sjd.job_id 
JOIN 
    skills_dim sd
ON  sjd.skill_id=sd.skill_id;
