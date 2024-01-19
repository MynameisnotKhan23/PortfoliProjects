SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4

Select location, date,total_cases, new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2


Select location, date,population,total_cases, (total_cases/population)*100 as PercentPopulationInfection
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
order by 1,2



Select location population, MAX(total_cases) AS HighestInfectionCount , MAX((total_cases/population))*100 as PercentPopulationInfection
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
Group by location, population
order by PercentPopulationInfection desc




Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
Where continent is not null 
Group by location
order by TotalDeathCount desc

--


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


--

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%United Kingdom%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



--

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Sweden%' 
Where continent is not null
--Group by date
order by 1,2

--


Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
, --(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3



--




Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
, --(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3









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







--
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





--



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