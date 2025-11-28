-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
	
WITH period AS (
	SELECT 
		min(payroll_year) AS first_year,
		max(payroll_year) AS last_year
	FROM t_barbora_rasticova_project_sql_primary_final tbrpspf 
)
SELECT 
	DISTINCT 
	b.payroll_year,
	b.category_name, 
	b.avg_annual_price_category,
	round(b.avg_annual_payroll_total::NUMERIC, 1) AS avg_anual_payroll_total,
	round((b.avg_annual_payroll_total / avg_annual_price_category)::NUMERIC, 1) AS quantity,
	b.price_unit 
FROM t_barbora_rasticova_project_sql_primary_final b
LEFT JOIN period p
	ON 1=1
WHERE 
	(b.category_name LIKE ('%Mléko%') OR b.category_name LIKE ('%Chléb%'))
	AND b.payroll_year IN (p.first_year, p.last_year)
ORDER BY 
	b.category_name ASC,
	b.payroll_year ASC 
	

































