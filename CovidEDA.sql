-- looking at data
DESCRIBE coviddeaths;
DESCRIBE covidvaccinations;

SELECT COUNT(*) FROM coviddeaths;
SELECT COUNT(*) FROM covidvaccinations;

SELECT *
FROM coviddeaths
LIMIT 5;

SELECT *
FROM covidvaccinations
LIMIT 5;

-- total cases and deaths (global)
SELECT 
    SUM(total_cases) AS total_global_cases,
    SUM(total_deaths) AS total_global_deaths
FROM 
    coviddeaths;

-- total cases and deaths (continents)
SELECT 
	continent,
    SUM(total_cases) AS total_global_cases,
    SUM(total_deaths) AS total_global_deaths
FROM 
    coviddeaths
GROUP BY 
	continent;
    
SELECT 
	continent, 
    MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM 
	coviddeaths
WHERE
	continent IS NOT NULL 
GROUP BY 
	continent
ORDER BY 
	total_death_count DESC;

-- total cases and deaths (United States)
SELECT 
	location,
    SUM(total_cases) AS total_cases,
    SUM(total_deaths) AS total_deaths,
    (SUM(total_deaths) / SUM(total_cases)) * 100 AS death_percentage
FROM 
	coviddeaths
WHERE 
	location = 'United States'
ORDER BY 1;

-- hospital patients and ICU patients (United States)
SELECT 
    AVG(hosp_patients) AS avg_hospital_patients,
    MAX(hosp_patients) AS max_hospital_patients,
    MIN(hosp_patients) AS min_hospital_patients,
    AVG(icu_patients) AS avg_icu_patients,
    MAX(icu_patients) AS max_icu_patients,
    MIN(icu_patients) AS min_icu_patients
FROM 
    coviddeaths
WHERE
	location = 'United States';
    
SELECT 
    location,
    date,
    SUM(hosp_patients) AS total_hospital_patients,
    SUM(icu_patients) AS total_icu_patients
FROM 
    coviddeaths
WHERE 
	location = 'United States'
GROUP BY 
    `date`
ORDER BY 
    `date` ASC;
    
-- population vs vaccinations
SELECT 
    t1.location, 
    t1.`date`, 
    t1.population, 
    t2.new_vaccinations,
    SUM(CAST(t2.new_vaccinations AS UNSIGNED)) 
        OVER (PARTITION BY t1.location ORDER BY t1.`date`) AS rolling_total_vaccinated
FROM 
    coviddeaths t1
JOIN 
    covidvaccinations t2
    ON t1.location = t2.location
    AND t1.`date` = t2.`date`
WHERE 
    t1.location = 'United States'
    AND t1.population IS NOT NULL
ORDER BY 
	't1.date' ASC;

-- monthly trends
SELECT 
    DATE_FORMAT(`date`, '%Y-%m') AS month,
    SUM(new_cases) AS monthly_new_cases,
    SUM(new_deaths) AS monthly_new_deaths
FROM 
    coviddeaths
GROUP BY 
    month
ORDER BY 
    month ASC;

SELECT 
    t1.location, 
    DATE_FORMAT(t1.`date`, '%Y-%m') AS month, 
    SUM(t1.new_cases) AS monthly_new_cases, 
    SUM(t1.new_deaths) AS monthly_new_deaths, 
    SUM(t2.new_vaccinations) AS monthly_vaccinations
FROM 
    coviddeaths t1
JOIN 
    covidvaccinations t2
ON 
    t1.location = t2.location 
    AND t1.`date` = t2.`date`
WHERE 
    t1.location = 'United States'
GROUP BY 
    t1.location, month
ORDER BY 
    month ASC;



    

    





