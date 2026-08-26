SELECT 
    job_title, 
    salary_year_avg * 0.8 avg_salary_80, 
    salary_year_avg * 1.2 avg_salary_120, 
    job_work_from_home 
FROM job_postings_fact
where (job_title like '%Data Engineer%' or job_title like '%Data Analyst%') 
and job_work_from_home = True
and  salary_year_avg IS NOT NULL
LIMIT 10;

/*
┌──────────────────────────────────────────────────────────────────┬───────────────┬────────────────┬────────────────────┐
│                            job_title                             │ avg_salary_80 │ avg_salary_120 │ job_work_from_home │
│                             varchar                              │    double     │     double     │      boolean       │
├──────────────────────────────────────────────────────────────────┼───────────────┼────────────────┼────────────────────┤
│ Data Engineer                                                    │     109856.25 │     164784.375 │ true               │
│ Data Engineer - Web3                                             │      154000.0 │       231000.0 │ true               │
│ Qlik/Power BI Data Analyst | $130K-$150K + ESOP |100% USA-Remote │      112000.0 │       168000.0 │ true               │
│ Senior Data Analyst                                              │      104000.0 │       156000.0 │ true               │
│ Data Analyst, Supply Chain (Remote)                              │       72000.0 │       108000.0 │ true               │
│ HR Data Analyst- REMOTE                                          │       47200.0 │        70800.0 │ true               │
│ Senior Data Engineer                                             │      108000.0 │       162000.0 │ true               │
│ REMOTE Sr. Data Engineer                                         │      124000.0 │       186000.0 │ true               │
│ Sr Data Engineer (REMOTE)                                        │      108480.0 │       162720.0 │ true               │
│ Senior Data Engineer                                             │      104000.0 │       156000.0 │ true               │
└──────────────────────────────────────────────────────────────────┴───────────────┴────────────────┴────────────────────┘
*/


 SELECT 
    count (*) count_of_jobs,
    job_location,  
    AVG(salary_year_avg) avg_salary
 from job_postings_fact
 group by job_location
 having AVG(salary_year_avg)> 120000
 LIMIT 10;

/*
┌───────────────┬──────────────────────────┬────────────────────┐
│ count_of_jobs │       job_location       │     avg_salary     │
│     int64     │         varchar          │       double       │
├───────────────┼──────────────────────────┼────────────────────┤
│          1671 │ California               │     143582.9046875 │
│          1647 │ Santa Clara, CA          │ 155500.82445652175 │
│          1500 │ Ottawa, ON, Canada       │ 127530.76666666666 │
│          2077 │ Denmark                  │           125732.5 │
│           634 │ Fort Meade, MD           │ 127499.35344827586 │
│          2009 │ Seattle, WA              │ 179252.22506107492 │
│           623 │ Malvern, PA              │  121830.0556640625 │
│            68 │ Mt Pleasant Township, PA │  132946.2142857143 │
│           430 │ Foster City, CA          │  152769.0892857143 │
│          1466 │ Fremont, CA              │  146550.7907436709 │
└───────────────┴──────────────────────────┴────────────────────┘
*/

SELECT 
    count(jpf.job_title) total_job, 
    cd.name company_name
from company_dim cd
join job_postings_fact jpf
on cd.company_id=jpf.company_id
group by cd.name
LIMIT 10;

/*
┌───────────┬───────────────────────────────┐
│ total_job │         company_name          │
│   int64   │            varchar            │
├───────────┼───────────────────────────────┤
│      2000 │ Hays                          │
│       289 │ Thomson Reuters               │
│       122 │ Dautom                        │
│        48 │ Webster Bank                  │
│        19 │ Methodist Hospital            │
│       137 │ Korn Ferry                    │
│       114 │ Tn Spain                      │
│        32 │ Staffline Recruitment Ireland │
│        26 │ Wayve                         │
│        26 │ Winnin                        │
└───────────┴───────────────────────────────┘
*/

SELECT 
    job_title, 
    job_location
from job_postings_fact
where job_title not like '%Senior%'
and salary_year_avg between 100000 and 150000
LIMIT 10;

/*
┌────────────────────────────────────────────────────┬───────────────────┐
│                     job_title                      │   job_location    │
│                      varchar                       │      varchar      │
├────────────────────────────────────────────────────┼───────────────────┤
│ Data Scientist                                     │ Calabasas, CA     │
│ Lead Data Scientist (Hybrid)                       │ Burnsville, MN    │
│ Data Science Manager                               │ Carnegie, PA      │
│ Data Scientist                                     │ Torrance, CA      │
│ Marketing Data Scientist                           │ Anywhere          │
│ Lead Scientist, Data Science - Remote (Dallas, TX) │ Texas             │
│ Data Scientist                                     │ Lexington, MA     │
│ Data Engineer                                      │ St. Louis, MO     │
│ Data Engineer                                      │ Goleta, CA        │
│ Data Engineer                                      │ San Francisco, CA │
└────────────────────────────────────────────────────┴───────────────────┘
*/



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

/*
┌──────────────────────────┬───────────┬───────────────────┐
│       job_location       │ total_job │    avg_salary     │
│         varchar          │   int64   │      double       │
├──────────────────────────┼───────────┼───────────────────┤
│ Tartu, Estonia           │       101 │           63000.0 │
│ Peachtree City, GA       │       101 │    84350.69921875 │
│ Ghana                    │       102 │           94055.5 │
│ La Crosse, WI            │       102 │     63951.6796875 │
│ Santa Rosa, CA           │       102 │          95342.25 │
│ San Pedro Sula, Honduras │       103 │           63000.0 │
│ Modesto, CA              │       103 │          85475.25 │
│ Kefar Sava, Israel       │       103 │ 91038.66666666667 │
│ Slough, UK               │       103 │           85000.0 │
│ St. Augustine, FL        │       104 │ 99593.33333333333 │
└──────────────────────────┴───────────┴───────────────────┘
*/

SELECT 
    job_id, 
    job_title,
    job_location, 
    job_work_from_home 
FROM job_postings_fact
where job_title not like '%Senior%'
and (LOWER(job_title) like '%remot%'
or job_location ='London')
limit 10;

/*
            limit 10;
┌────────┬─────────────────────────────────────────────────────────────┬─────────────────┬────────────────────┐
│ job_id │                          job_title                          │  job_location   │ job_work_from_home │
│ int32  │                           varchar                           │     varchar     │      boolean       │
├────────┼─────────────────────────────────────────────────────────────┼─────────────────┼────────────────────┤
│   4639 │ REMOTE - CTDS Data Scientist                                │ Anywhere        │ true               │
│   4644 │ Data Scientist/ Remote ( Hartford ,CT ), 12 Months Contract │ Anywhere        │ true               │
│   4725 │ Data Engineer (Remoto)                                      │ Madrid, Spain   │ false              │
│   4726 │ Data Engineer - 100% Remoto                                 │ Málaga, Spain   │ false              │
│   4793 │ Assc Dir- Data Engineer (100% Remote - Throughout US)       │ Anywhere        │ true               │
│   4849 │ Data Engineer - Chicago, IL - Remote                        │ Anywhere        │ true               │
│   4892 │ Data Scientist / Engineer Remote 30000 - 35000 GBP          │ Bristol, UK     │ false              │
│   4913 │ Data Engineer (remote)                                      │ Farnborough, UK │ false              │
│   4988 │ Principal Data Engineer / 100% Remote / Kafka               │ Los Angeles, CA │ false              │
│   5104 │ Insurance – Data Analyst – REMOTE                           │ Charlotte, NC   │ false              │
└────────┴─────────────────────────────────────────────────────────────┴─────────────────┴────────────────────┘
*/

SELECT 
    job_id, 
    job_title,
    job_location, 
FROM job_postings_fact
where job_id % 5 =0
limit 10;

/*
┌────────┬───────────────────────────────────────────────────────────┬───────────────────┐
│ job_id │                         job_title                         │   job_location    │
│ int32  │                          varchar                          │      varchar      │
├────────┼───────────────────────────────────────────────────────────┼───────────────────┤
│   4595 │ Data Analyst                                              │ Fairfax, VA       │
│   4600 │ Loyalty Data Analyst III                                  │ Pleasanton, CA    │
│   4605 │ Data Analyst                                              │ Irvine, CA        │
│   4610 │ Data Analyst, Partner Operations (Ecosystem Partnerships) │ San Francisco, CA │
│   4615 │ Business Analyst - III                                    │ Foster City, CA   │
│   4620 │ Data analyst                                              │ Irving, TX        │
│   4625 │ Data Analyst/Report Writer 3                              │ Austin, TX        │
│   4630 │ Business Data Analyst  Data Visualization with SQL        │ Princeton, IN     │
│   4635 │ Senior data engineer                                      │ Gainesville, FL   │
│   4640 │ Data Scientist                                            │ Vienna, VA        │
└────────┴───────────────────────────────────────────────────────────┴───────────────────┘
*/

SELECT 
    job_id, 
    job_title,
    job_location, 
    salary_year_avg,
    salary_year_avg / 280 as day_salary, 
    FROM job_postings_fact
order by day_salary desc
limit 10;

/*
┌─────────┬──────────────────────────────────────────────────────────┬────────────────────────┬─────────────────┬────────────────────┐
│ job_id  │                        job_title                         │      job_location      │ salary_year_avg │     day_salary     │
│  int32  │                         varchar                          │        varchar         │     double      │       double       │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│  296745 │ Data Scientist                                           │ Madison, SD            │        960000.0 │ 3428.5714285714284 │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│ 1231950 │ Data Science Manager - Messaging and Inferred Identity D │ California             │        920000.0 │  3285.714285714286 │
│         │ SE at Netflix in Los Gatos, California, United States    │                        │                 │                    │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│  673003 │ Senior Data Scientist                                    │ Pretoria, South Africa │        890000.0 │ 3178.5714285714284 │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│ 1575798 │ Machine Learning Engineer                                │ Florida, NY            │        875000.0 │             3125.0 │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│ 1007105 │ Machine Learning Engineer/Data Scientist                 │ South Africa           │        870000.0 │ 3107.1428571428573 │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│  856772 │ Data Scientist                                           │ Dulles, VA             │        850000.0 │  3035.714285714286 │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│ 1443865 │ Senior Data Engineer (MDM team), DTG                     │ Prague, Czechia        │        800000.0 │ 2857.1428571428573 │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│ 1591743 │ AI/ML (Artificial Intelligence/Machine Learning) Enginee │ South Africa           │        800000.0 │ 2857.1428571428573 │
│         │ r                                                        │                        │                 │                    │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│ 1574285 │ Data Scientist , Games [Remote]                          │ Anywhere               │        680000.0 │ 2428.5714285714284 │
├─────────┼──────────────────────────────────────────────────────────┼────────────────────────┼─────────────────┼────────────────────┤
│  142665 │ Data Analyst                                             │ Anywhere               │        650000.0 │ 2321.4285714285716 │
└─────────┴──────────────────────────────────────────────────────────┴────────────────────────┴─────────────────┴────────────────────┘
  */

