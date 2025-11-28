/*
 * Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin 
 * či mzdách ve stejném nebo následujícím roce výraznějším růstem?
 */

CREATE TABLE t_barbora_rasticova_project_SQL_secondary_final AS
WITH economy_data AS (
	SELECT DISTINCT 
		e.country,
		e."year",
		e.gdp,
		e.gini,
		e.population 
	FROM economies e
),
country_data AS (
	SELECT DISTINCT 
		country,
		continent,
		population
	FROM countries c 
),
date_data AS (
	SELECT 
		min(payroll_year) AS first_year,
		max(payroll_year) AS last_year 
	FROM t_barbora_rasticova_project_sql_primary_final tbrpspf 
)
SELECT 
	ed.country,
	ed."year",
	ed.gdp,
	ed.gini,
	ed.population 		-- populace použita z původní tabulky economies, protože jsou zde data (populace) pro každý rok, v tabulce countries je pouze jedna hodnota pro neznámý rok
FROM economy_data ed
LEFT JOIN country_data cd
	ON ed.country = cd.country 
CROSS JOIN date_data dd
WHERE ed."year" BETWEEN  dd.first_year AND dd.last_year
	AND cd.continent = 'Europe'
ORDER BY ed.country ASC, ed."year" ASC 







