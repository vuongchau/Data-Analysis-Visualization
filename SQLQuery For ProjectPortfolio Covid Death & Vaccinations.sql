SELECT *
FROM [PortfolioProject].[dbo].[CovidDeaths$]
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM [PortfolioProject].[dbo].[CovidVaccinations$]
--ORDER BY 3,4

SELECT location, DATE, total_cases, new_cases, total_deaths, population
FROM [PortfolioProject].[dbo].[CovidDeaths$]
ORDER BY 1,2

--1/ Percentage of likelihood of dying if you have Covid in each Country (total death vs total cases)
SELECT location, DATE, total_cases, total_deaths, population, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [PortfolioProject].[dbo].[CovidDeaths$]
WHERE continent IS NOT NULL
ORDER BY 1,2

--2/ Percentage of population have Covid
SELECT location, DATE, total_cases, population, (total_cases/population)*100 AS CovidInfectPopulation
FROM [PortfolioProject].[dbo].[CovidDeaths$]
WHERE continent IS NOT NULL
ORDER BY 1,2

--3/ Highest Infection Rate compared to Population in each country
SELECT location, max(total_cases) AS HighestInfectionCount, population, max((total_cases/population))*100 AS CovidPercentage
FROM [PortfolioProject].[dbo].[CovidDeaths$]
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC

--4/  Highest Death Cases Rate compared to Population in each continent
SELECT continent, max(cast(total_deaths as int)) AS TotalDeathCount
FROM [PortfolioProject].[dbo].[CovidDeaths$]
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--5/ Global Death Percentage/Total Cases
SELECT SUM (new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, 
SUM (cast(new_deaths as int))/SUM (new_cases) *100 AS DeathPercentage
FROM [PortfolioProject].[dbo].[CovidDeaths$]
WHERE continent IS NOT NULL
ORDER BY 1,2 

--6/ Total Vaccination vs Population
-- Use CTE
WITH POPULATION_VS_VACCINATIONS (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT DEA.continent, DEA.location, DEA.DATE, DEA.population, VAC.new_vaccinations,
SUM(CONVERT (INT,VAC.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY DEA.LOCATION, DEA.DATE) 
AS RollingPeopleVaccinated
FROM [PortfolioProject].[dbo].[CovidDeaths$] AS DEA
JOIN [PortfolioProject].[dbo].[CovidVaccinations$] AS VAC
ON DEA.LOCATION= VAC.location AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM POPULATION_VS_VACCINATIONS 

-- TEMPT TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
LOCATION  NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
ROLLINGPEOPLEVACCINATED NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT DEA.continent, DEA.location, DEA.DATE, DEA.population, VAC.new_vaccinations,
SUM(CONVERT (INT,VAC.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY DEA.LOCATION, DEA.DATE) 
AS RollingPeopleVaccinated
FROM [PortfolioProject].[dbo].[CovidDeaths$] AS DEA
JOIN [PortfolioProject].[dbo].[CovidVaccinations$] AS VAC
ON DEA.LOCATION= VAC.location AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated AS 
SELECT DEA.continent, DEA.location, DEA.DATE, DEA.population, VAC.new_vaccinations,
SUM(CONVERT (INT,VAC.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY DEA.LOCATION, DEA.DATE) 
AS RollingPeopleVaccinated
FROM [PortfolioProject].[dbo].[CovidDeaths$] AS DEA
JOIN [PortfolioProject].[dbo].[CovidVaccinations$] AS VAC
ON DEA.LOCATION= VAC.location AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL


