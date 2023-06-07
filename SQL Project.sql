--SELECT *
--FROM Portfolio..CovidDeaths
--ORDER BY 3,4

--SELECT *
--FROM Portfolio..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths in a Specific Country which is Canada

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio..CovidDeaths
WHERE location like 'Can%'
ORDER BY 1,2


-- what percentage of Canadian Population got covid
SELECT location, date, population, total_cases, new_cases, total_deaths, (total_deaths/population)*100 as PercentpopulationInfected
FROM Portfolio..CovidDeaths
WHERE location like 'Can%'
ORDER BY 1,2



--Looking at countries with highest infection rate compared to population

SELECT location, population, max(total_cases) as highestinfection, Max((total_deaths/population))*100 as PercentpopulationInfected
FROM Portfolio..CovidDeaths
Group By location, population
ORDER BY PercentpopulationInfected desc

--Showing countries with highest death count per popualtion

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM Portfolio..CovidDeaths
Group By location
Order By TotalDeathCount desc


--Converting total_deaths data type from nvarchar to integar and group by with continent
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio..CovidDeaths
WHERE continent is not null
Group By continent
Order By TotalDeathCount desc

--GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS newcases, SUM(cast(new_deaths as int)) as newdeaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
FROM Portfolio..CovidDeaths
WHERE continent is not null
Group by date
ORDER BY 1,2

SELECT *
FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date


SELECT *
FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
order by 1,2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Looking at Total Population and Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated,
(PeopleVaccinated/population)*100
FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, PeopleVaccinated)
As
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

)
Select *, (PeopleVaccinated/Population)*100
FROM popvsvac

--Temp Table

Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated

FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select *, (PeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



--Drop Temp Table

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated

FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null

Select *, (PeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


--Creating View to Store Data

Create view PrcntPopulationVaccinated as 


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated

FROM portfolio..coviddeaths dea
join portfolio..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


Select *
FROm PercentPopulationVaccinated