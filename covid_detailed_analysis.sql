select*
from covid_deaths;

select count(distinct location)
from covid_deaths;

select min(date), max(date), datediff(max(date),min(date)) as DayDiffferenece
from covid_deaths;


select  date, max(new_cases)
from covid_deaths
group by date
order by max(new_cases) desc;


select `date`, sum(population)
from covid_deaths
where date like '2020-05-24' and continent is not null
group by `date`;


SELECT 
    SUM(latest_population) AS TotalPopulation
FROM (
    SELECT 
        location,
        MAX(population) AS latest_population
    FROM 
        covid_deaths
	where continent is not null
    GROUP BY 
        location
) AS subquery;

select location, max(total_cases)
from covid_deaths
group by 1
order by 2 desc;

select location, max(cast(total_deaths as signed))
from covid_deaths
where continent is not null
group by 1
order by 2 desc;

select location, max(cast(total_deaths as signed))
from covid_deaths
where continent is  null 
group by 1
order by 2 desc;

-- titoeuli qveynis maqsimaluri new_case ert dgeshi, date-is gareshe
select location, max(new_cases)
from covid_deaths
where continent is not null
group by 1
order by 2 desc;

-- titoeuli qveynis maqsimaluri new_case ert dgeshi, date-it
WITH MaxCasesPerLocation AS (
    SELECT 
        location, 
        MAX(new_cases) AS max_new_cases
    FROM covid_deaths
    WHERE continent IS NOT NULL
    GROUP BY location
)
SELECT 
    cd.location, 
    mc.max_new_cases, 
    cd.date
FROM covid_deaths cd
JOIN MaxCasesPerLocation mc
ON cd.location = mc.location AND cd.new_cases = mc.max_new_cases
ORDER BY mc.max_new_cases DESC;



WITH MaxCasesPerLocation AS (
    SELECT 
        location, 
        MAX(new_cases) AS max_new_cases
    FROM covid_deaths
    WHERE continent IS  NULL
    GROUP BY location
)
SELECT 
    cd.location, 
    mc.max_new_cases, 
    cd.date
FROM covid_deaths cd
JOIN MaxCasesPerLocation mc
ON cd.location = mc.location AND cd.new_cases = mc.max_new_cases
ORDER BY mc.max_new_cases DESC;

-- ess imenaa lokaciia sadac 
select location, population, total_cases, (total_cases/population)*100 as percentageinfected
from covid_deaths
order by 4 desc;

select location, population, max(total_cases) as HIghestInfection, MAX((total_cases/population))*100 as PercentPopulationInfcted
from restaurant.covid_deaths
group by location, population
order by 4 desc ;

-- ubralod rom andoraa rom date davamato




-- death rate, general, higest, lowest

select location, population, cast(total_deaths as signed), (total_deaths/population)*100 as death_rate
from covid_deaths
where continent is not null
order by 4 desc;

select location, population, max(cast(total_deaths as signed)), max((total_deaths/population))*100 as death_rate
from covid_deaths
where continent is not null
group by location, population
order by 4 desc;

--
select location, new_cases, new_deaths, total_deaths, population
from covid_deaths
where new_cases=' ' or new_cases is null
or new_deaths=' ' or new_deaths is null
or total_deaths=' ' or total_deaths is null
or population=' ' or population is null;


-- me-8 dan vagrdzelebt
select*
from covid_deaths
order by date desc;

select location,date, new_cases, avg(new_cases)
from covid_deaths
WHERE date BETWEEN '2021-04-23' AND '2021-04-30'
group by location,date, new_cases;


with avgincrease as
(select location,date, new_cases, avg(new_cases) as avgnewcases
from covid_deaths
WHERE date BETWEEN '2021-04-23' AND '2021-04-30'
group by location,date, new_cases
)select location,date, new_cases,
avg(avgnewcases) over (order by location) as avgcases
from avgincrease;



with sfasf as
(select location,date, new_cases, avg(new_cases) as avgnewcases
from covid_deaths
WHERE date BETWEEN '2021-04-23' AND '2021-04-30'
group by location,date, new_cases
), gsdf as
( select location,date, new_cases,
avg(avgnewcases) over (order by location) as avgcases,
dense_rank () over (partition by location order by avgnewcases desc) as ranking
from sfasf)
select *
from gsdf
where ranking <=7;


-- 9

select location, date, population, max(new_cases), max(new_deaths)
from covid_deaths
group by location, date, population
order by 4 desc;

select location, max(total_deaths), max(total_cases)
from covid_deaths
where continent is not null
group by location
order by 3 desc;



WITH mostinfectedpercentage AS (
    SELECT 
        location, 
        population, 
        max((total_cases / population)) * 100 AS percentageinfected,
        max((total_deaths / total_cases)) * 100 AS deathrate
    FROM covid_deaths
    WHERE continent IS NOT NULL
    group by location, population
)
SELECT 
    location, 
    population, 
    ROUND(percentageinfected, 2) AS percentageinfected, 
    ROUND(deathrate, 2) AS deathrate
FROM mostinfectedpercentage
WHERE location IN ('United States', 'India') -- Replace with wanted country names
ORDER BY location;





