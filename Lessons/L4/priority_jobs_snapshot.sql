SELECT * from range(5) as src(key)
where not exists (
    select 1 from range (4) as tgt(key)
    where tgt.key=src.key
);

SELECT * from job_postings_fact as tgt
where  exists (
    select 1 from skills_job_dim as src
    where tgt.job_id=src.job_id
)
order by job_id;

USE jobs_mart;
select * from staging.priority_roles;

CREATE OR REPLACE TABLE main.priority_jobs_snapshot(
	job_id INTEGER PRIMARY KEY,
	job_title_short varchar,
	company_name varchar,
	job_posted_date TIMESTAMP,
	salary_year_avg DOUBLE,
	priority_lvl INTEGER,
	updated_at TIMESTAMP
);

INSERT INTO main.priority_jobs_snapshot(
	job_id ,
	job_title_short ,
	company_name ,
	job_posted_date ,
	salary_year_avg ,
	priority_lvl ,
	updated_at 
)SELECT 
 	jpf.job_id ,
	jpf.job_title_short ,
	cd.name as company_name ,
	jpf.job_posted_date ,
	jpf.salary_year_avg,
	r.priority_lvl ,
	CURRENT_TIMESTAMP
FROM 
	data_jobs.job_postings_fact jpf
LEFT JOIN data_jobs.company_dim cd
	on jpf.company_id=cd.company_id
INNER JOIN staging.priority_roles r
	on jpf.job_title_short=r.role_name;


-----------

CREATE OR REPLACE TEMP TABLE src_priority_jobs AS 
SELECT 
 	jpf.job_id ,
	jpf.job_title_short ,
	cd.name as company_name ,
	jpf.job_posted_date ,
	jpf.salary_year_avg,
	r.priority_lvl ,
	CURRENT_TIMESTAMP as updated_at
FROM 
	data_jobs.job_postings_fact jpf
LEFT JOIN data_jobs.company_dim cd
	on jpf.company_id=cd.company_id
INNER JOIN staging.priority_roles r
	on jpf.job_title_short=r.role_name;

-----
INSERT INTO main.priority_jobs_snapshot(
	job_id ,
	job_title_short ,
	company_name ,
	job_posted_date ,
	salary_year_avg ,
	priority_lvl ,
	updated_at 
)SELECT 
 	src.job_id ,
	src.job_title_short ,
	src.company_name,
	src.job_posted_date ,
	src.salary_year_avg,
	src.priority_lvl ,
	src.updated_at 
FROM src_priority_jobs as src
where not exists
(SELECT 1 FROM main.priority_jobs_snapshot as tgt
where tgt.job_id=src.job_id);

--select * from priority_jobs_snapshot;
------------------

DELETE FROM main.priority_jobs_snapshot as tgt
WHERE NOT EXISTS (
    SELECT 1 
    FROM src_priority_jobs as src
    WHERE src.job_id=tgt.job_id
);
--------------------
UPDATE main.priority_jobs_snapshot as tgt
SET 
    priority_lvl=src.priority_lvl,
    updated_at=src.updated_at
FROM src_priority_jobs as src
where tgt.job_id=src.job_id
    AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;
-----------------

MERGE INTO main.priority_jobs_snapshot as tgt
USING src_priority_jobs as src
on tgt.job_id=src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN 
UPDATE SET 
    priority_lvl=src.priority_lvl,
    updated_at=src.updated_at
WHEN NOT MATCHED THEN
    INSERT (
        job_id ,
        job_title_short ,
        company_name ,
        job_posted_date ,
        salary_year_avg ,
        priority_lvl ,
        updated_at 
    )VALUES(
        src.job_id ,
        src.job_title_short ,
        src.company_name,
        src.job_posted_date ,
        src.salary_year_avg,
        src.priority_lvl ,
        src.updated_at )
WHEN NOT MATCHED BY SOURCE THEN DELETE;

--------------------

SELECT 
	job_title_short,
	count(*) as job_count,
	MIN(priority_lvl) as priority_lvl,
	MIN(updated_at) as updated_at
from priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;