CREATE TABLE t_barbora_rasticova_project_SQL_primary_final AS  
WITH base AS (
	SELECT 
		--czechia_payroll:
		cp.id AS id_payroll, 
		cp.payroll_year,
		cp.value AS payroll,
		cp.value_type_code,
		cpvt.name AS value_type_name,  					
		cp.industry_branch_code,							
		cpib.name AS industry_branch_name,					
		--czechia_price:
		cpr.id AS id_price,
		date_part('year', cpr.date_from) AS price_year,
		cpr.value AS value_price,
		cpr.category_code,
		cpc.name AS category_name,
		cpc.price_value AS quantity,
		cpc.price_unit
	FROM czechia_payroll cp 
	LEFT JOIN czechia_payroll_industry_branch cpib 
		ON cp.industry_branch_code = cpib.code
	LEFT JOIN czechia_payroll_value_type cpvt 
		ON cp.value_type_code = cpvt.code
	LEFT JOIN czechia_price cpr 
		ON date_part('year', cpr.date_from) = cp.payroll_year
		AND cpr.region_code IS NOT NULL 			--  NULL = jedná se o celorepublikový průměr
	LEFT JOIN czechia_price_category cpc 
		ON cpr.category_code = cpc.code
	WHERE cp.calculation_code = 200 				-- 200 calculation_code--> přepočtěný = tj. ukazuje mzdu vztaženou na 1 celý pracovní úvazek – tzv. FTE (Full-Time Equivalent) =  tedy zaměstnanci přepočítaní na plný úvazek					
		AND cp.value_type_code = 5958
		AND cpr.category_code != 212101			-- nezahrnutí hodnot pro Jakostní víno bílé	
		),	
-- přepočet na jednotné porovnatelné data
category_units AS (
	SELECT *,
	--přepočet ceny 
		CASE 
			WHEN category_name = 'Jogurt bílý netučný' THEN round((value_price * (1000.0/150.0))::NUMERIC ,1) -- cena převedena na 1 kg 
			WHEN category_name = 'Pivo výčepní, světlé, lahvové' THEN round((value_price / 0.5):: NUMERIC ,1) -- cena převedena na 1 l 
			ELSE value_price  
		END AS value_price_corrected, 
	--přepis množství na jednotnou míru
		CASE 
			WHEN category_name = 'Jogurt bílý netučný' THEN 1 
			WHEN category_name = 'Pivo výčepní, světlé, lahvové' THEN 1
			ELSE quantity
		END AS quantity_corrected,
	-- přepis jednotek 
		CASE 
			WHEN category_name = 'Jogurt bílý netučný' THEN 'kg'
			WHEN category_name = 'Pivo výčepní, světlé, lahvové' THEN 'l'
			ELSE price_unit 
		END AS price_unit_corrected 
	FROM base 
),
-- počet průměrné roční ceny dané kategorie potravin pro všechny kategorie
avg_price_category AS (			
	SELECT 
	cu.price_year,
	cu.category_name,
	round(avg(cu.value_price_corrected)::NUMERIC, 1) AS avg_annual_price_category  
FROM category_units cu
GROUP BY 
	price_year,
	category_name
),
-- výpočet celkové průměrné ceny potravin ročně 
avg_price_total AS (
	SELECT 
		avp.price_year,
		round(avg(avp.avg_annual_price_category)::NUMERIC,1) AS avg_annual_price_total
	FROM avg_price_category avp
	GROUP BY price_year 
),
-- výpočet průměrné roční mzdy pro jednotlivá odvětví
avg_payroll_category AS (
	SELECT
		b.payroll_year,
		b.industry_branch_name,
		round(avg(b.payroll):: NUMERIC, 1) AS avg_annual_payroll_category 
	FROM base b 
	GROUP BY 
		payroll_year,
		industry_branch_name 
),
--výpočet průměrné roční mzdy napříč všechny kategoriemi
avg_payroll AS (
	SELECT 
		apc.payroll_year,
		round(avg(avg_annual_payroll_category)::NUMERIC, 1) AS avg_annual_payroll_total 
	FROM avg_payroll_category apc
	GROUP BY 
		apc.payroll_year
)
--výsledná tabulka	
SELECT 
	cu.id_payroll,
	cu.payroll_year,
	cu.payroll,
	avg_payroll.avg_annual_payroll_total,
	cu.industry_branch_code,
	cu.industry_branch_name,
	cu.id_price,
	cu.category_code,
	cu.category_name,
	cu.value_price_corrected AS value_price,
	cu.quantity_corrected AS quantity,
	cu.price_unit_corrected AS price_unit,
	avg_price_category.avg_annual_price_category,
	avg_price_total.avg_annual_price_total
FROM category_units cu 
LEFT JOIN avg_price_category 
	ON avg_price_category.price_year = cu.price_year 
	AND avg_price_category.category_name = cu.category_name 
LEFT JOIN avg_price_total
	ON avg_price_total.price_year = cu.payroll_year
LEFT JOIN avg_payroll
	ON avg_payroll.payroll_year = cu.payroll_year 
WHERE cu.payroll_year IN (
	SELECT DISTINCT date_part('year', date_from)
	FROM czechia_price
)


