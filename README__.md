# 📊 Analýza cen potravin a mezd v ČR (2006–2018)
**Projekt 4 – Engeto Online Python Akademie**

**Autor:** Barbora Rašticová  
**Email:** rasticova.barbora@seznam.cz  
**Soubory:** 
- `t_barbora_rasticova_project_SQL_primary_final.sql` – primární tabulka obsahující data mezd a cen potravin za Českou Republiku sjednocených na totožné porovnatelné období 
- `t_barbora_rasticova_project_SQL_secondary_final.sql` – sekundární tabulka obsahující dodatečná data (HDP, GINI, koeficienty, populace..) o evropských státech   
- `q1_trend_wages.sql` – analýza vývoje mezd v jednotlivých odvětvích  
- `q2_bread_liters_wage.sql` – výpočet dostupnosti chleba a mléka za průměrnou mzdu  
- `q3_cheapest_categories.sql` – identifikace kategorií potravin s nejpomalejším růstem cen (CAGR)  
- `q4_price_vs_wage_gap.sql` – porovnání meziročního růstu cen potravin a mezd  
- `q5_hdp_influence.sql` – analýza vztahu HDP k vývoji mezd a cen potravin

Bližší popis jednotlivých souborů v sekci **Popis zpracování dat**. 

---

## 1️⃣ Cíl projektu

Cílem projektu je porovnat **vývoj cen základních potravin** a **průměrných mezd** v České republice za porovnatelné období a vyhodnotit:

- jak se měnila cenová dostupnost potravin,
- zda mzdy rostly rychleji než ceny,
- které potraviny zdražují nejpomaleji,
- kolik lze za průměrnou mzdu koupit vybraných potravin,
- zda makroekonomické ukazatele (HDP, GINI, populace) souvisejí s vývojem cen a mezd.

Součástí projektu je také vytvoření sekundárního datasetu s ekonomickými ukazateli vybraných evropských zemí pro stejné období.

---
## 2️⃣ Použité datové zdroje

### **A. České otevřené datové sady (ČSÚ – oficiální open data)**  
Z *Portálu otevřených dat ČR / ČSÚ* (pro účely Akademie byla data upravena):

- `czechia_payroll` – údaje o průměrných mzdách  
- `czechia_payroll_industry_branch` – číselník odvětví  
- `czechia_payroll_value_type` – číselník typů hodnot  
- `czechia_price` – přehled cen vybraných potravin  
- `czechia_price_category` – číselník kategorií potravin  

### **B. Doplňkové tabulky (data dostupná pouze v rámci Engeto Databáze)**  
Použity pouze jako rozšiřující informační zdroje:

- `countries` – obecné informace o zemích světa  
- `economies` – HDP, GINI, daňová zátěž, populace 

Všechny tabulky jsou také k dispozici přímo v repozitáři ve formátu **CSV**.

---

##  3️⃣ Popis zpracování dat 

### Primární tabulka  (`t_barbora_rasticova_project_SQL_primary_final`)

Výchozí datový podklad pro všechny analýzy týkající se České republiky. 
Obsahuje data o **průměrných mzdách** a **cenách potravin** sjednocených na totožné porovnatelné období (**2006 – 2018**).

**Hlavní kroky zpracování:**

- spojení tabulek cen a mezd podle roku,
- filtrování pouze na záznamy s `calculation_code = 200` (přepočtená hodnota na 1 úvazek),
- výpočet průměrných ročních cen potravin dvoustupňovým průměrem:
  1) průměr za kategorii potravin,  
  2) následně výpočet celkového průměru,
- sjednocení jednotek (například 150 g ➝ 1 kg, 0,5 l ➝ 1 l),
- identifikace a odstranění záznamů s nedostatečným pokrytím dat (např. `212101 – Jakostní víno bílé`, dostupné až od roku 2015),
- identifikace anomálií v číselnících a jejich korekce (např. přehozené jednotky u hodnot 316 a 5958).

### Sekundární tabulka (`t_barbora_rasticova_project_SQL_secondary_final`)
 Rozšiřující datový soubor zahrnující vybrané evropské státy a jejich ekonomické ukazatele (HDP, GINI, populace). 

**Hlavní kroky zpracování:**

- sjednocení tabulek populace a ekonomických ukazatelů podle roku
- omezení časového období na roky 2006–2018 na základě dat z primární tabulky
- odstranění duplicitních záznamů v obou tabulkách
- vyloučení Zemí bez kompletních údajů (cyhbějící data o GDP, GINI a populaci)
  1) Holy See (Vatican City State)
  2) Northern Ireland
  3) Svalbard and Jan Mayen

---

## 4️⃣  Výzkumné otázky:

### 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Odkazuje na soubor `q1_trend_wages.sql`

U všech sledovaných kategorií dochází průměrně k nárůstu mezd.  
Rychlost růstu se u jednotlivých kategorií liší – u některých je mírnější, u jiných výraznější – nicméně ve všech případech dochází k postupnému zvyšování.  
Pro lepší srovnání byla data také exportována a vizualizována v Excelu. Kvůli přehlednosti graf zachycuje pouze 5 odvětví s nejvyššími průměrnými mzdami jako ilustrativní příklad.

![](ukol_1_.png)

---

### 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Odkazuje na soubor `q2_bread_liters_wage.sql`

- **2006**: 1309,6 kg chleba nebo 1464,2 litrů mléka  
- **2018**: 1365,2 kg chleba nebo 1668,6 litrů mléka  

---

### 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Odkazuje na soubor `q3_cheapest_categories.sql`

*Pozn. Pro výpočet průměrného meziročního růstu byl použit ukazatel **CAGR** (Compound Annual Growth Rate) pro jednotlivé kategorie potravin. Tento ukazatel umožňuje vyjádřit celkový růst za celé sledované období formou průměrného ročního tempa a tím také snadněji porovnat vývoj mezi jednotlivými kategoriemi potravin.*

Výsledky ukazují, že u dvou sledovaných potravin – **cukru krystalu a rajských jablek** – je hodnota CAGR záporná, tzn. v průběhu sledovaného období došlo k mírnému zlevnění.  
U ostatních kategorií je CAGR kladné. Nejnižší meziroční nárůst mezi nimi vykazují **banány (0,59 %)**, a lze je tedy označit za potravinu, která zdražovala nejpomaleji.

---

### 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Odkazuje na soubor `q4_price_vs_wage_gap.sql`

**Ne.** V analyzovaných datech ani v jednom roce nepřevýšil meziroční nárůst cen potravin meziroční růst mezd o více než 10 procentních bodů.  
Nejvyšší rozdíl byl zaznamenán v roce **2013**, kdy ceny potravin rostly výrazněji než mzdy – konkrétně o **6,8 procentních bodů**.

---

### 5) Má výška HDP vliv na změny ve mzdách a cenách potravin?

Odkazuje na soubor `q5_hdp_influence.sql`

**MZDY:** Vývoj HDP má do určité míry vliv na mzdy s cca 1ročním zpožděním – firmy reagují na růst ekonomiky zvýšením platů. Toto tvrzení ale neplatí celkově pro všechny sledované roky.  
Například:

- HDP prudce kleslo v roce 2009 (−4,7 %) → mzdy výrazněji zpomalily růst v roce 2010 (+1,9 %).
- V roce 2014 vzrostl HDP o 2,3 %, ale mzdy zůstaly téměř stejné jako předchozí rok (+2,6 % v roce 2014, stejně jako v 2013, kdy HDP bylo 0 %).


**CENY POTRAVIN:** Vazba na HDP je velmi slabá, a to jak ve stejném, tak následujícím roce. Vývoj cen potravin tak může ovlivňovat více faktorů (např. klimatické vlivy, zemědělská produkce).  
Například:

- Růst HDP v roce 2015 (+5,4 %) byl následován poklesem cen potravin v roce 2016 (−1,5 %).
- Naopak v roce 2017, kdy HDP vzrostl o 5,2 %, se ceny potravin zvýšily až o 10 % – zde se souvislost zdá zřetelnější.

---

## 5️⃣ Použité principy a SQL techniky

- **Základní práce s daty** – SELECT, DISTINCT, aliasy, práce se sloupci  
- **Filtrování a řazení** – WHERE, ORDER BY, BETWEEN, IN, IS NOT NULL  
- **Agregační funkce** – AVG, SUM, COUNT, dvoustupňové průměry  
- **Podmíněná logika** – CASE WHEN (tvorba nových hodnot podle podmínek)  
- **Spojování tabulek** – LEFT JOIN, CROSS JOIN  
- **CTE (Common Table Expressions)** – strukturování složitějších kroků do přehledných bloků  
- **Vnořené SELECTy (subqueries)** – poddotazy v SELECT, FROM i WHERE části  
- **Tvorba tabulek a pohledů** – CREATE TABLE, CREAT VIEW
- **Window funkce** – LAG, LEAD pro výpočet meziročních změn  
- **Časové funkce** – date_part('year', …) pro extrakci roku  
- **Výpočty a matematické funkce** – POWER, procentní změny, různé poměrové ukazatele  
- **Přetypování datových typů** – CAST, ::numeric, práce s číselnými přesnostmi  


