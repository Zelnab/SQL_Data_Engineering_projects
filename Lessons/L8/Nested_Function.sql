--build a flat skill table for co-workers to access job titles, salary info, and skills in one table


CREATE OR REPLACE TEMP TABLE job_skills_array as
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills)as skills_array
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd
    ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim as sd
    ON sd.skill_id=sjd.skill_id
GROUP BY ALL;

--from the perspective of a data analyst, analyze the median salary per skill

with flat_skills as(
SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array)as skill
FROM
    job_skills_array
)
SELECT median(salary_year_avg)as median_salary,skill
FROM flat_skills
GROUP BY skill
ORDER BY median_salary desc
LIMIT 10;

/*
┌───────────────┬──────────────┐
│ median_salary │    skill     │
│    double     │   varchar    │
├───────────────┼──────────────┤
│      182350.0 │ fedora       │
│      173500.0 │ mongo        │
│      173000.0 │ debian       │
│      165000.0 │ haskell      │
│      160000.0 │ apl          │
│     157956.75 │ hugging face │
│      157500.0 │ puppet       │
│     155391.25 │ watson       │
│      155000.0 │ rust         │
│      155000.0 │ dplyr        │
└───────────────┴──────────────┘
*/

-- build a flat skill and type table for co-workers to access job titles, salary info, skills and type in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct as
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills))as skills_type
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd
    ON jpf.job_id=sjd.job_id
LEFT JOIN skills_dim as sd
    ON sd.skill_id=sjd.skill_id
GROUP BY ALL;


with flat_skills_type as(
SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type as skills_type,
    UNNEST(skills_type).skill_name as skills_name
FROM
    job_skills_array_struct
)
SELECT median(salary_year_avg)as median_salary,skills_type
FROM flat_skills_type
GROUP BY skills_type
ORDER BY  median_salary desc;

/*
┌───────────────┬───────────────┐
│ median_salary │  skills_type  │
│    double     │    varchar    │
├───────────────┼───────────────┤
│      140000.0 │ libraries     │
│      132500.0 │ cloud         │
│      130000.0 │ other         │
│      125000.0 │ databases     │
│      125000.0 │ webframeworks │
│      125000.0 │ programming   │
│      125000.0 │ sync          │
│      122087.0 │ os            │
│      120000.0 │ async         │
│      103000.0 │ analyst_tools │
│      100430.0 │ NULL          │
└───────────────┴───────────────┘
*/
