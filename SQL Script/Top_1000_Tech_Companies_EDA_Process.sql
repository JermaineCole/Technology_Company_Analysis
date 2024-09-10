# Exploratory Data Analysis Process

# 1. Top 10 companies based on market cap

SELECT
  Ranking,
  Company,
  Market_Cap
FROM
  top_1000_technology_companies_dev_2
ORDER BY
  Ranking
LIMIT 10;
  
# 2. Top 3 companies based on percentage of market cap

SELECT
  Ranking,
  Company,
  ROUND((Market_Cap / (
    SELECT
      SUM(Market_Cap)
    FROM
      top_1000_technology_companies_dev_2)),2) * 100 AS Percentage_Market_Cap
FROM
  top_1000_technology_companies_dev_2
ORDER BY
  Percentage_Market_Cap DESC
LIMIT 3;

# 3. Most represented countries in top 1000

SELECT
  Country,
  SUM(Market_Cap) AS Total_Market_Cap,
  ROUND((SUM(Market_Cap) / (SELECT SUM(Market_Cap) FROM top_1000_technology_companies_dev_2)),2) * 100 AS Market_Cap_Percentage
FROM
  top_1000_technology_companies_dev_2
GROUP BY
  Country
ORDER BY
  Total_Market_Cap DESC
LIMIT 4;

# 4. Top 2 countries percentage of total companies

SELECT
  Country,
  ROUND((COUNT(Company) / (
    SELECT
      COUNT(Company)
    FROM
      top_1000_technology_companies_dev_2)),2) * 100 AS Percentage_of_Total_Companies
FROM
  top_1000_technology_companies_dev_2
GROUP BY
  Country
ORDER BY
  Percentage_of_Total_Companies DESC
LIMIT 2;

# 5. Top 5 leading industries

SELECT
  Industry,
  COUNT(Company) AS Total_Companies
FROM
  top_1000_technology_companies_dev_2
GROUP BY
  Industry
ORDER BY
  Total_Companies DESC
LIMIT 5;

# 6. Top 2 countries with most companies in leading industries by percentage

SELECT
  Country,
  ROUND((COUNT(Company) / (
    SELECT
      COUNT(Company)
    FROM
      top_1000_technology_companies_dev_2)),2) * 100 AS Percentage_of_Total_Companies
FROM
  top_1000_technology_companies_dev_2
WHERE
  Industry IN (
	'Software Application',
    'Semiconductors',
    'Information Technology Services',
    'Electronic Components',
    'Software Infrastructure')
GROUP BY
  Country
ORDER BY
  Percentage_of_Total_Companies DESC
LIMIT 2;

# 7. Top 4 countries in the top 5 leading industries by total companies and market cap
  
SELECT
  Country,
  Industry,
  COUNT(Company) AS Total_Companies
FROM
  top_1000_technology_companies_dev_2
WHERE
  Industry IN (
	'Software Application',
    'Semiconductors',
    'Information Technology Services',
    'Electronic Components',
    'Software Infrastructure')
GROUP BY
  Country,
  Industry
ORDER BY
Country, Industry;

    
WITH RankedCountries AS (
    SELECT
        Country,
        Industry,
        COUNT(Company) AS Total_Companies,
        SUM(market_cap) AS Total_Market_Cap,
        ROW_NUMBER() OVER (PARTITION BY Industry ORDER BY COUNT(Company) DESC) AS rn
    FROM
        top_1000_technology_companies_dev_2
    WHERE
        Industry IN (
            'Software Application',
            'Semiconductors',
            'Information Technology Services',
            'Electronic Components',
            'Software Infrastructure'
        )
    GROUP BY
        Country,
        Industry
)
SELECT
    Country,
    Industry,
    Total_Companies,
    Total_Market_Cap 
FROM
    RankedCountries
WHERE
    rn <= 4
ORDER BY
    Industry, rn;



