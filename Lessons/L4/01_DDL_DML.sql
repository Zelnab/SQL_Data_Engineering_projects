--.read Lessons/L4/DDL_DML.sql
USE data_jobs;

--DROP DATABASE IF EXISTS jobs_mart;

CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

USE jobs_mart;
--DROP SCHEMA IF EXISTS staging;
CREATE SCHEMA IF NOT EXISTS staging;

SELECT * FROM information_schema.schemata
WHERE catalog_name='jobs_mart';


--DROP table IF EXISTS staging.preferred_roles;
CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    rol_id INTEGER PRIMARY KEY,
    rol_name VARCHAR
);

SELECT * FROM information_schema.tables
WHERE table_catalog='jobs_mart';

INSERT INTO staging.preferred_roles(rol_id,rol_name)
VALUES 
    (1,'Data Engineer'),
    (2,'Senior Data Engineer'),
    (3,'Software Engineer');  

SELECT * FROM staging.preferred_roles;

ALTER TABLE staging.preferred_roles
--DROP COLUMN preferred_role;
ADD COLUMN preferred_role BOOLEAN;

UPDATE staging.preferred_roles
SET preferred_role= FALSE
WHERE rol_id=3;

--DROP TABLE staging.preferred_roles;

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

SELECT * FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl=3
WHERE rol_id=3;


SELECT * FROM staging.priority_roles;