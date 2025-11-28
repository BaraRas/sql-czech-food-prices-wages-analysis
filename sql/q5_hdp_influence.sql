/*
 * Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin 
 * či mzdách ve stejném nebo následujícím roce výraznějším růstem?
 */

WITH cz_data AS (
	SELECT 
		"year",
		gdp 
	FROM t_barbora_rasticova_project_sql_secondary_final tbrpssf 
	WHERE country = 'Czech Republic'
),
lag_gdp AS (
	SELECT 
	*,
	LAG(gdp) OVER (ORDER BY "year") AS gdp_prev_year
	FROM cz_data
),
gdp_percent AS (
	SELECT *,
	round(((gdp - gdp_prev_year) / (gdp_prev_year)*100)::NUMERIC , 1) AS annual_percent_gdp
	FROM lag_gdp lg
)
SELECT 
	gp."year",
	vag.annual_percent_payroll,
	vag.annual_percent_price,
	gp.annual_percent_gdp
FROM gdp_percent gp
LEFT JOIN v_annual_grow vag 
	ON gp."year" = vag.payroll_year 
WHERE annual_percent_payroll IS NOT NULL 
ORDER BY gp."year" ASC 
















