select *
from restaurant.covid_deaths
order by 3,4;

-- select date that we ar going to using

select location, `date`, total_cases, new_cases, total_deaths, population
from restaurant.covid_deaths
order by 1,2 ;

-- looking at total_cases vs total Deaths
-- date type change first 
select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from restaurant.covid_deaths;

update restaurant.covid_deaths
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table restaurant.covid_deaths
modify column `date` DATE;


-- shows dying if you contract covid in your country.

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from restaurant.covid_deaths
where location like '%georgia%'
order by 1,2 ;


-- what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from restaurant.covid_deaths
where location like '%georgia%'
order by 1,2 ;


-- highest infection rates compare to population

select location, population, max(total_cases) as HIghestInfection, MAX((total_cases/population))*100 as PercentPopulationInfcted
from restaurant.covid_deaths
group by location, population
order by 4 desc ;

-- countries with highest death rate per population
select location, population, max(cast(total_deaths as signed)), MAX((total_deaths/population))*100 as PercentPopulationdeath
from restaurant.covid_deaths
group by location, population
order by 3 desc ;

-- cause without it it shouws continents
update restaurant.covid_deaths
set continent=null
where continent=' ';

select location, max(cast(total_deaths as signed)) as max_total_death
from restaurant.covid_deaths
where continent is not null 
group by location
order by 2 desc;

select location, max(cast(total_deaths as signed)) as max_total_death
from restaurant.covid_deaths
where continent is null 
group by location
order by 2 desc;

-- showing continents with higest deathcount

select continent, max(cast(total_deaths as signed)) as max_total_death
from restaurant.covid_deaths
where continent is not null 
group by continent
order by 2 desc;

-- global numbers

select `date`, sum(new_cases), sum(cast(new_deaths as signed)),
sum(cast(new_deaths as signed))/sum(new_cases)*100 as total_death
from restaurant.covid_deaths
where continent is not null
group by `date`
order by 1,2;

select  sum(new_cases), sum(cast(new_deaths as signed)),
sum(cast(new_deaths as signed))/sum(new_cases)*100 as total_death
from restaurant.covid_deaths
where continent is not null
order by 1,2;


-- second table
select*
from restaurant.covid_vacinations;

select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from restaurant.covid_vacinations;

update restaurant.covid_vacinations
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table restaurant.covid_vacinations
modify column `date` DATE;
 
    
select *
from restaurant.covid_deaths dea
join restaurant.covid_vacinations vac
	on dea.location=vac.location
    and dea.date=vac.date;
    
-- total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, dea.date
) 
from restaurant.covid_deaths dea
join restaurant.covid_vacinations vac
	on dea.location=vac.location
    and dea.date=vac.date
where dea.continent is not null
order by 2,3;

-- use cte    
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, dea.date
) as RollingPeopleVaccinated
from restaurant.covid_deaths dea
join restaurant.covid_vacinations vac
	on dea.location=vac.location
    and dea.date=vac.date
where dea.continent is not null
order by 2,3;


with PopVsVac (continent, location, `date`, population, new_vaccinations, RollingPeopleVaccinated) 
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, dea.date
) as RollingPeopleVaccinated
from restaurant.covid_deaths dea
join restaurant.covid_vacinations vac
	on dea.location=vac.location
    and dea.date=vac.date
where dea.continent is not null
order by 2,3
)
select*, (RollingPeopleVaccinated/population)*100
from PopVsVac;


-- temp table
CREATE table PercentPopulationVaccinated
(
continent varchar(255),
location varchar(255),
date datetime,
population numeric(15,2),
new_vaccinations numeric(15,2),
RollingPeopleVaccinated numeric(15,2)
);

insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, dea.date
) as RollingPeopleVaccinated
from restaurant.covid_deaths dea
join restaurant.covid_vacinations vac
	on dea.location=vac.location
    and dea.date=vac.date
order by 2,3;

select*, (RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated;
 
 
 -- view
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, dea.date
) as RollingPeopleVaccinated
from restaurant.covid_deaths dea
join restaurant.covid_vacinations vac
	on dea.location=vac.location
    and dea.date=vac.date
where dea.continent is not null;
-- order by 2,3