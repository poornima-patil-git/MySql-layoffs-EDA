-- Exploratory Data Analysis

select * 
from layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_staging2
WHERE  percentage_laid_off = 1;

-- if we order by funcs_raised_millions we can see how big some of these companies were
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised desc;

-- Companies with the most Total Layoffs
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging2;

-- by industry
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- this it total in the past 3 years or in the dataset
select * 
from layoffs_staging2;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by YEAR(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc;

-- Rolling Total of Layoffs Per Month
with Rolling_Total as
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off, 
sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company, YEAR(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
order by company asc;

select company, YEAR(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
order by 3 desc;

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. 
with Company_Year (company, years, total_laid_off) as
(
select company, YEAR(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
), Company_Year_Rank as
(select *, dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select *
from Company_Year_Rank
where Ranking <=5;









