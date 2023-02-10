--Covid Deaths Table

Select * from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4

--Covid Vaccinations Table

Select * from PortfolioProject.dbo.CovidVaccinations
order by 3,4

-- Selecting data that is goin to be used

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2

-- Going over Total cases vs Total Deaths
-- Death Percentage by Country who contract covid

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null and location like 'India'
order by 1,2

-- Going over Total Cases vs Population
-- Percentage of population who contract covid

Select Location, date, Population, total_cases, (total_cases/Population)*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
-- where location like 'India'
order by 1,2

-- Going over Highest Infection Rate compared to the Population

Select Location, Population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/Population))*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
-- where location like 'India'
group by Location, Population
order by InfectedPopulationPercentage desc

-- Going over Countries with Highest Death Count

Select Location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject.dbo.CovidDeaths
where continent is not null
-- where location like 'India'
group by Location
order by Total_Death_Count desc

-- Going over Continents with Highest Death Count

Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject.dbo.CovidDeaths
where continent is not null
-- where location like 'India'
group by continent
order by Total_Death_Count desc

-- Death percentage across the world for each day

Select SUM(new_cases) as Total_Casess, SUM(cast(new_deaths as int)) as Total_Deathss, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Death_Percentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
-- where location like 'India'
--group by date
order by 1,2

-- Total Death percentage across the world

Select SUM(new_cases) as Totall_Casess, SUM(cast(new_deaths as int)) as Total_Deathss, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Death_Percentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
-- where location like 'India'
--group by date
order by 1,2

--Going over Total Population Vs vaccinations by location and date
	--Using CTE

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

	-- Temp table

--Dropping temp table if exists
DROP Table if exists #PercentPopulusVaccinated

--Creating Temp Table
Create Table #PercentPopulusVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinations numeric
);

Insert into #PercentPopulusVaccinated
Select CoviD.continent, CoviD.location, CoviD.date, CoviD.population, CoviV.new_vaccinations
, SUM(CONVERT(bigint, CoviV.new_vaccinations)) OVER (Partition by CoviD.Location Order by CoviD.location, CoviD.date) as RollingVaccinations
from PortfolioProject.dbo.CovidDeaths CoviD
Join PortfolioProject.dbo.CovidVaccinations CoviV
	On CoviD.location = CoviV.location
	and CoviD.date = CoviV.date
where CoviD.continent is not null

Select *,  (RollingVaccinations/Population)*100
from #PercentPopulusVaccinated
order by 2,3


--Creating a view
CREATE VIEW PercentagePopulusVaccinated as
Select CoviD.continent, CoviD.location, CoviD.date, CoviD.population, CoviV.new_vaccinations
, SUM(CONVERT(bigint, CoviV.new_vaccinations)) OVER (Partition by CoviD.Location order by CoviD.location, CoviD.date) as RollingVaccinations
from PortfolioProject.dbo.CovidDeaths CoviD
Join PortfolioProject.dbo.CovidVaccinations CoviV
	On CoviD.location = CoviV.location
	and CoviD.date = CoviV.date
where CoviD.continent is not null

select * from PercentagePopulusVaccinated


