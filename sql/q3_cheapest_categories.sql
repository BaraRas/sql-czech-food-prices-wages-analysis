-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

-- první dostupný rok + cena
WITH first_year_price AS (
	SELECT DISTINCT 
		category_name, 
		payroll_year AS first_year,
		avg_annual_price_category AS first_price 
	FROM t_barbora_rasticova_project_sql_primary_final b
	WHERE payroll_year = (
			SELECT min(payroll_year) 
			FROM t_barbora_rasticova_project_sql_primary_final b) 
),
-- poslední dostupný rok + cena 
last_year_price AS (
	SELECT DISTINCT 
		category_name, 
		payroll_year AS last_year,
		avg_annual_price_category AS last_price 
	FROM t_barbora_rasticova_project_sql_primary_final b
	WHERE payroll_year = (
			SELECT max(payroll_year) 
			FROM t_barbora_rasticova_project_sql_primary_final b) 
)
SELECT 
	f.category_name,
	f.first_year,
	l.last_year,
	f.first_price,
	l.last_price,
	l.last_year - f.first_year AS years,
	round(((power(l.last_price/f.first_price, 1.0 / (l.last_year - f.first_year)) - 1) *100)::NUMERIC, 2) AS cagr_percent 
FROM first_year_price f
LEFT JOIN last_year_price l
	ON f.category_name = l.category_name 
WHERE f.first_price IS NOT NULL 
	AND l.last_price IS NOT NULL 
ORDER BY cagr_percent ASC 




