/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT  
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 1) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((LN(COUNT(jpf.*)) * MEDIAN(jpf.salary_year_avg))/1_000_000, 2) AS optimal_score
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_work_from_home = True 
GROUP BY
    sd.skills
HAVING 
    COUNT(sjd.job_id) >= 100
ORDER BY
    optimal_score DESC
LIMIT 10;



/*
Summary:
Skills that consistently appear near the top balance a strong combination of market demand (job security) and financial benefit. Python, SQL, AWS, Spark, Airflow, and Terraform are particularly strategic for both immediate opportunities and longer-term career growth in data engineering.

┌───────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│  skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar  │    double     │    int64     │     double      │    double     │
├───────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform │      184000.0 │          193 │             5.3 │          0.97 │
│ python    │      135000.0 │         1133 │             7.0 │          0.95 │
│ sql       │      130000.0 │         1128 │             7.0 │          0.91 │
│ aws       │      137320.3 │          783 │             6.7 │          0.91 │
│ airflow   │      150000.0 │          386 │             6.0 │          0.89 │
│ spark     │      140000.0 │          503 │             6.2 │          0.87 │
│ kafka     │      145000.0 │          292 │             5.7 │          0.82 │
│ snowflake │      135500.0 │          438 │             6.1 │          0.82 │
│ azure     │      128000.0 │          475 │             6.2 │          0.79 │
│ java      │      135000.0 │          303 │             5.7 │          0.77 │
└───────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
  10 rows                                                          5 columns

*/