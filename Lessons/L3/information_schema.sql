
/*information_schema*/

SELECT column_name,data_type 
FROM information_schema.columns 
where table_name = 'company_dim'; 
/*
┌─────────────┬───────────┐
│ column_name │ data_type │
│   varchar   │  varchar  │
├─────────────┼───────────┤
│ company_id  │ INTEGER   │
│ name        │ VARCHAR   │
│ link        │ VARCHAR   │
│ link_google │ VARCHAR   │
│ thumbnail   │ VARCHAR   │
└─────────────┴───────────┘
*/


SELECT * 
FROM information_schema.tables 
WHERE table_schema = 'main';

select 
    table_name, 
    constraint_name, 
    constraint_text  
from  information_schema.constraint_column_usage
where constraint_type='PRIMARY KEY' and table_catalog ='data_jobs';

/*
┌───────────────────┬─────────────────────────────────────┬───────────────────────────────┐
│    table_name     │           constraint_name           │        constraint_text        │
│      varchar      │               varchar               │            varchar            │
├───────────────────┼─────────────────────────────────────┼───────────────────────────────┤
│ company_dim       │ company_dim_company_id_pkey         │ PRIMARY KEY(company_id)       │
│ job_postings_fact │ job_postings_fact_job_id_pkey       │ PRIMARY KEY(job_id)           │
│ skills_dim        │ skills_dim_skill_id_pkey            │ PRIMARY KEY(skill_id)         │
│ skills_job_dim    │ skills_job_dim_skill_id_job_id_pkey │ PRIMARY KEY(skill_id, job_id) │
│ skills_job_dim    │ skills_job_dim_skill_id_job_id_pkey │ PRIMARY KEY(skill_id, job_id) │
└───────────────────┴─────────────────────────────────────┴───────────────────────────────┘
*/


select   
    table_name, 
    constraint_name, 
    constraint_text  
from information_schema.constraint_column_usage
where constraint_type='FOREIGN KEY' and table_catalog ='data_jobs';

/*
┌───────────────────┬──────────────────────────────────────────────┬─────────────────────────────────────────────────────────────┐
│    table_name     │               constraint_name                │                       constraint_text                       │
│      varchar      │                   varchar                    │                           varchar                           │
├───────────────────┼──────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ job_postings_fact │ job_postings_fact_company_id_company_id_fkey │ FOREIGN KEY (company_id) REFERENCES company_dim(company_id) │
│ skills_job_dim    │ skills_job_dim_skill_id_skill_id_fkey        │ FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id)      │
│ skills_job_dim    │ skills_job_dim_job_id_job_id_fkey            │ FOREIGN KEY (job_id) REFERENCES job_postings_fact(job_id)   │
└───────────────────┴──────────────────────────────────────────────┴─────────────────────────────────────────────────────────────┘
*/


CREATE SCHEMA analysis;
CREATE TABLE IF NOT EXISTS analysis.top_paying_jobs (
    job_id INTEGER PRIMARY KEY
);

CREATE TABLE company_locations (
    company_id INTEGER,
    FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
);

