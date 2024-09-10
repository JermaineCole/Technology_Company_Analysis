# Data Cleaning Process

SELECT * 
FROM top_1000_technology_companies;

# Duplicate Table for development process

CREATE TABLE top_1000_technology_companies_dev
LIKE top_1000_technology_companies;

INSERT INTO top_1000_technology_companies_dev
SELECT *
FROM top_1000_technology_companies;

CREATE TABLE top_1000_technology_companies_dev_2
LIKE top_1000_technology_companies_dev;

INSERT INTO top_1000_technology_companies_dev_2
SELECT *
FROM top_1000_technology_companies_dev;

# Data cleaning

SELECT * 
FROM top_1000_technology_companies_dev;

# Renaming column

ALTER TABLE top_1000_technology_companies_dev
RENAME COLUMN `market cap` TO Market_Cap;

# Removing special characters and formatting

SELECT industry, REGEXP_REPLACE(industry, '[â€]','')
FROM top_1000_technology_companies_dev;

UPDATE top_1000_technology_companies_dev
SET industry = REGEXP_REPLACE(industry, '[â€]','');

SELECT industry, REGEXP_REPLACE(industry, '[”]',' ')
FROM top_1000_technology_companies_dev;

UPDATE top_1000_technology_companies_dev
SET industry = REGEXP_REPLACE(industry, '[”]',' ');

# Converting column to correct format

SELECT 
    CASE
        WHEN Market_Cap LIKE '%B%' THEN CAST(REPLACE(REPLACE(Market_Cap, '$', ''), 'B', '') AS DECIMAL(20, 2)) * 1000000000
        WHEN Market_Cap LIKE '%M%' THEN CAST(REPLACE(REPLACE(Market_Cap, '$', ''), 'M', '') AS DECIMAL(20, 2)) * 1000000
        WHEN Market_Cap LIKE '%T%' THEN CAST(REPLACE(REPLACE(Market_Cap, '$', ''), 'T', '') AS DECIMAL(20, 2)) * 1000000000000
        ELSE CAST(REPLACE(Market_Cap, '$', '') AS DECIMAL(20, 2))
    END AS Market_Cap
FROM 
    top_1000_technology_companies_dev;

UPDATE top_1000_technology_companies_dev_2
SET Market_Cap = CASE
	WHEN Market_Cap LIKE '%B%' THEN CAST(REPLACE(REPLACE(Market_Cap, '$', ''), 'B', '') AS DECIMAL(20, 2)) * 1000000000
	WHEN Market_Cap LIKE '%M%' THEN CAST(REPLACE(REPLACE(Market_Cap, '$', ''), 'M', '') AS DECIMAL(20, 2)) * 1000000
	WHEN Market_Cap LIKE '%T%' THEN CAST(REPLACE(REPLACE(Market_Cap, '$', ''), 'T', '') AS DECIMAL(20, 2)) * 1000000000000
	ELSE CAST(REPLACE(Market_Cap, '$', '') AS DECIMAL(20, 2))
	END;

SELECT * 
FROM top_1000_technology_companies_dev_2;

ALTER TABLE top_1000_technology_companies_dev_2
MODIFY stock VARCHAR(10);





