SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4

	
--Selecting data that i'm going to be using
	
Select location, date,total_cases, new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
Select location, date,population,total_cases, (total_cases/population)*100 as PercentPopulationInfection
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
order by 1,2

--Looking at Total Cases vs Population 
--Shows what percentage of population got covid	

Select location population, MAX(total_cases) AS HighestInfectionCount , MAX((total_cases/population))*100 as PercentPopulationInfection
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
Group by location, population
order by PercentPopulationInfection desc


--Showing continents with the highest death count per population	


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
Where continent is not null 
Group by location
order by TotalDeathCount desc

	
--Global Numbers


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))SUM(New_cases)*100 DeathPercentage
From PortfolioProject..CovidDeaths
Where location is like '%United Kingdom%'
--Group by data 
Order by 1,2




--Looking at Total Population vs Vaccination


Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
, --(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3



-- Using CTE



With PopsvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopsvsVac







--Using TEMP TABLE
	
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RolllingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

Select *, (RolllingPeopleVaccinated/Population)*100 
From #PercentPopulationVaccinated





-- Creating data to store for later visualization



Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3


Select *
From PercentPopulationVaccinated
