--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
/*
 * oproti 3 úkolu, kde byl použit CAGR zde byla použita window funkce lag pro výpočet meziročního růstu pro jednotlivé roky 
 * tj. hledám konkrétní rok, potřebuji hodnoty pro všechny roky, nikoliv jen jednu průměrnou hodnotu růstu 
 */

CREATE VIEW v_annual_grow AS 	-- tvorba VIEW pro 5. úkol 
WITH filtered_data AS (
	SELECT DISTINCT 
		payroll_year,
		avg_annual_payroll_total,
		avg_annual_price_total
	FROM t_barbora_rasticova_project_sql_primary_final tbrpspf 
	WHERE category_code != 212101
),
lag_data AS(
	SELECT 
		*,
		lag(f.avg_annual_payroll_total) OVER (ORDER BY f.payroll_year) AS prev_year_payroll,
		lag(f.avg_annual_price_total) OVER (ORDER BY payroll_year) AS prev_year_total
	FROM filtered_data f
), 
annual_percent_data AS (
	SELECT 
		*, 
		round((l.avg_annual_payroll_total - l.prev_year_payroll) / (l.prev_year_payroll) * 100, 1) AS annual_percent_payroll,
		round((l.avg_annual_price_total - l.prev_year_total) / (l.prev_year_total) * 100, 1) AS annual_percent_price 
	FROM lag_data l 
),
diff_data AS (
	SELECT 
		*,
		a.annual_percent_price - a.annual_percent_payroll AS diff_categ_payroll
	FROM annual_percent_data a 
) 
SELECT 
	d.payroll_year,
	d.annual_percent_payroll,
	d.annual_percent_price,
	d.diff_categ_payroll 
FROM diff_data d 
WHERE 
	diff_categ_payroll IS NOT NULL 
ORDER BY diff_categ_payroll DESC 

















