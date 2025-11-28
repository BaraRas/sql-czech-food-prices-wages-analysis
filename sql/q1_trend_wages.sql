
-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT 
	payroll_year,
	round(avg(payroll)::NUMERIC, 0),
	industry_branch_name 
FROM t_barbora_rasticova_project_sql_primary_final base 
WHERE industry_branch_name IS NOT NULL 
GROUP BY 
	payroll_year,
	industry_branch_name 
ORDER BY 
	industry_branch_name ASC,
	payroll_year ASC 
	




