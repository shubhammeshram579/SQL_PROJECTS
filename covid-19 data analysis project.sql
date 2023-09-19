SELECT * FROM PortfolioProject..coviddeaths

--SELECT data that used are going to be using --

SELECT location ,date,total_cases,total_deaths,new_cases,population 
FROM PortfolioProject..coviddeaths
ORDER BY 1,2,3

--locking at total cases vs total deaths --
--show likehood of dying if ypou contract covid in you countery--

SELECT location ,date,(total_deaths/total_cases)*100 as deathpercentages 
FROM PortfolioProject..coviddeaths
WHERE location like '%INDIA%'
ORDER BY 1,2,3




--Looking at total cases vs population --
--show what percentages of population got covind --

SELECT location ,date,(total_cases/population)*100 as deathspercentages  
FROM PortfolioProject..coviddeaths
ORDER BY 1,2,3

--looking for all countries total sum deaths and new cases --

SELECT continent, location,sum(population),sum(total_cases),sum(new_cases),sum(population)
FROM PortfolioProject..coviddeaths
WHERE continent is not null
GROUP BY continent,location
ORDER BY location desc

--looking at all  counties max deaths and new cases --

SELECT continent, location,max(population),max(total_cases),max(new_cases),max(population)
FROM PortfolioProject..coviddeaths
WHERE continent is not null
GROUP BY continent,location
ORDER BY location desc

--looking for second  highst death and new cases-- 

SELECT location,max(total_deaths)
FROM PortfolioProject..coviddeaths
WHERE total_deaths in (SELECT max(total_deaths) FROM PortfolioProject..coviddeaths)
GROUP BY location
union
SELECT location,max(total_cases)
FROM PortfolioProject..coviddeaths
WHERE total_cases in (SELECT max(total_cases) FROM PortfolioProject..coviddeaths)
GROUP BY location


--looking at counties with highste infecctite rate comper to population --

SELECT location ,population,max(total_cases) as highhestpercentagecount ,max((total_cases/population ))*100 as percentagespopulationinfected
FROM PortfolioProject..coviddeaths
GROUP BY location,population
ORDER BY 1,2

--showing counties with hihhest deaths count per population--

SELECT location ,max(cast(total_deaths as int)) as totaldeathscount
FROM PortfolioProject..coviddeaths
GROUP BY location 
ORDER BY totaldeathscount desc

--lest breck this down BY continent--

SELECT location ,max(cast(total_deaths as int)) as totaldeathscount
FROM PortfolioProject..coviddeaths
WHERE continent is not null
GROUP BY location 
ORDER BY totaldeathscount desc


-- continent is null --

SELECT location ,max(cast(total_deaths as int)) as totaldeathscount
FROM PortfolioProject..coviddeaths
WHERE continent is  null
GROUP BY location 
ORDER BY totaldeathscount desc



--showing continent with in light death count per population --

SELECT continent ,max(cast(total_deaths as int)) as totaldeathscount
FROM PortfolioProject..coviddeaths
WHERE continent is not null
GROUP BY continent 
ORDER BY totaldeathscount desc

--multiple table JOIN--

SELECT * FROM PortfolioProject..coviddeaths d
JOIN PortfolioProject..vaccination v
on d.location = v.location
and d.date = v.date


--looking at total population vs vaccination--
--used CTE--

With Popvsv (Continent, Location, Date, Population, New_vaccinations, RollingPeoplevaccinated)
as
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT (int,v.new_vaccinations))OVER (Partition BY d.Location ORDER BY d .location, d .Date)as RollingPeoplevaccinated
--, (RollingPeoplevcinated/population)*l00
FROM PortfolioProject..coviddeaths d
JOIN PortfolioProject..Covidvaccination v
On d.location = v .location
and d .date = v .date 
WHERE d .continent is not null
--ORDER BY 2,3--
)
SELECT *, (RollingPeoplevaccinated/population)*100 as rollingpeolepercentage
FROM Popvsv 



--temp teble--

Create Table #rollingpeoplepercentage
(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric ,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #rollingpeoplepercentage
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT (numeric,v.new_vaccinations))OVER (Partition BY d.Location ORDER BY d .location, d .Date)as RollingPeoplevaccinated
--, (RollingPeoplevcinated/population)*l00
FROM PortfolioProject..coviddeaths d
JOIN PortfolioProject..Covidvaccination v
On d.location = v .location
and d .date = v .date 
WHERE d .continent is not null
--ORDER BY 2,3--

SELECT *, (RollingPeoplevaccinated/population)*100 #rollingpeoplepercentage
FROM #rollingpeoplepercentage



--create view table--

create view percentagepopulationvaccination as
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT (numeric,v.new_vaccinations))OVER (Partition BY d.Location ORDER BY d .location, d .Date)as RollingPeoplevaccinated
--, (RollingPeoplevcinated/population)*l00
FROM PortfolioProject..coviddeaths d
JOIN PortfolioProject..Covidvaccination v
On d.location = v .location
and d .date = v .date 
WHERE d .continent is not null
--ORDER BY 2,3--