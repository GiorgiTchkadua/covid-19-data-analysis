select *
from restaurant.covid_deaths;

select sum(population)
from covid_deaths
where `date` like '2020-05-01'
and continent is not null;


select sum(sumpopulation)
from covid_deaths,
(select location,
 max(population) as sumpopulation
from covid_deaths
where continent is not null
group by location
) as subquery;


select location, max(cast(total_deaths as signed))
from covid_deaths
where continent is not null
group by location
order by 2 desc;

with maxnewcases as
 (
select location, max(new_cases) as newcasesmax
from covid_deaths
where continent is not null
group by 1)
select cd.location,
mn.newcasesmax,
cd.date
from covid_deaths cd
join maxnewcases mn
on cd.location=mn.location and cd.new_cases=mn.newcasesmax
order by newcasesmax desc;

select location, date, avg(new_cases)
from covid_deaths
where continent is not null and
date between '2021-01-02' and '2021-03-25'
group by 1,2;

with avgnewcases as
(select location, date, avg(new_cases) as avgcases
from covid_deaths
where continent is not null and
date between '2021-01-02' and '2021-03-25'
group by 1,2)
select location, date,
avg(avgcases) over (order by location) as avgcases
from avgnewcases;

with avgnewcases as
(select location, date, avg(new_cases) as avgcases
from covid_deaths
where continent is not null and
date between '2021-01-02' and '2021-03-25'
group by 1,2), gdff as
(select location, date,
avg(avgcases) over (order by location) as avgcases,
dense_rank() over (partition by location order by avgcases desc) as ranking
from avgnewcases)
select *
from gdff
where ranking<=5
order by location, ranking desc;

-- hjgjg
select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from restaurant.covid_deaths;

update restaurant.covid_deaths
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table restaurant.covid_deaths
modify column `date` DATE;

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as signed)) over (partition by dea.location order by dea.location, dea.date
) 
from restaurant.covid_deaths dea
join restaurant.covid_vacinations vac
	on dea.location=vac.location
    and dea.date=vac.date
where dea.continent is not null
order by 2,3;






