--Queries used for Data Visualization in Tableau

--1
Select SUM(new_cases) as Total_Casess, SUM(cast(new_deaths as int)) as Total_Deathss, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Death_Percentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
-- where location like 'India'
--group by date
order by 1,2

--2
Select location, sum(cast(new_deaths as int)) as Total_Death_Count
from PortfolioProject.dbo.CovidDeaths
where continent is null
and location not in  ('World','International', 'European Union','High income',
'Upper middle income','Low income','Lower middle income')
group by location
order by Total_Death_Count desc

--3
Select Location, Population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/Population))*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
--where continent is not null
-- where location like 'India'
group by Location, Population
order by InfectedPopulationPercentage desc

--4
Select Location, Population, date , MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/Population))*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
-- where location like 'India'
group by Location, Population, date
order by InfectedPopulationPercentage desc


--Extra queries 
-------------------------------

Select CoviD.continent, CoviD.location, CoviD.date, CoviD.population, CoviV.new_vaccinations
, MAX(CoviV.total_vaccinations) as RollingVaccinations
from PortfolioProject.dbo.CovidDeaths CoviD
Join PortfolioProject.dbo.CovidVaccinations CoviV
	On CoviD.location = CoviV.location
	and CoviD.date = CoviV.date
where CoviD.continent is not null 
-- where location like 'India'
group by CoviD.continent, CoviD.location, CoviD.date
order by 1,2,3


Select SUM(new_cases) as Total_Casess, SUM(cast(new_deaths as int)) as Total_Deathss, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Death_Percentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
-- where location like 'India'
--group by date
order by 1,2


Select location, sum(cast(new_deaths as int)) as Total_Death_Count
from PortfolioProject.dbo.CovidDeaths
where continent is null
and location not in  ('World','International', 'European Union','High income',
'Upper middle income','Low income','Lower middle income')
group by location
order by Total_Death_Count desc

--3
Select Location, Population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/Population))*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
--where continent is not null
-- where location like 'India'
group by Location, Population
order by InfectedPopulationPercentage desc

Select Location, date, total_cases, population, total_deaths
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2

With PopsVsVaccs (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinations)
as
(
Select CoviD.continent, CoviD.location, CoviD.date, CoviD.population, CoviV.new_vaccinations
, SUM(CONVERT(bigint, CoviV.new_vaccinations)) OVER (Partition by CoviD.Location Order by CoviD.location, CoviD.date) as RollingVaccinations
from PortfolioProject.dbo.CovidDeaths CoviD
Join PortfolioProject.dbo.CovidVaccinations CoviV
	On CoviD.location = CoviV.location
	and CoviD.date = CoviV.date
where CoviD.continent is not null
)
Select *,  (RollingVaccinations/Population)*100
from PopsVsVaccs
order by 2,3

Select Location, Population, date , MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/Population))*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
--where continent is not null
-- where location like 'India'
group by Location, Population, date
order by InfectedPopulationPercentage desc