--1
use movies;
select case 
	when year(birthdate)<1960 then 'before1960'
	when year(birthdate)>=1960 and year(birthdate)<=1969
		then '60s'
	when year(birthdate)>=1970 and year(birthdate)<=1979
		then '70s'
	else 'after1980'
	end,
	count(name) as Stars
from moviestar
group by case
			when year(birthdate) < 1960 then 'before1960'
			when year(birthdate) >= 1960 and year(birthdate) <=1969 then '60s'
			when year(birthdate) >= 1970 and year(birthdate) <=1979 then '70s'
			else 'after1980'
		end;


select case 
	when year(birthdate)<1960 then 'older than 1960'
	when year(birthdate)>=1960 and year(birthdate)<=1969
		then '60s'
	when year(birthdate)>=1970 and year(birthdate)<=1979
		then '70s'
	else 'younger than 1980'
	end,
	count(name)
from moviestar
group by case 
	when year(birthdate)<1960 then 'older than 1960'
	when year(birthdate)>=1960 and year(birthdate)<=1969
		then '60s'
	when year(birthdate)>=1970 and year(birthdate)<=1979
		then '70s'
	else 'younger than 1980'
	end;

--2
use ships;
select battle
from outcomes o
join ships s on s.name=o.ship
join classes c on c.class=s.class
where c.numguns<9
group by battle
having count(*)>=3 and sum(case result when 'ok' then 1 else 0 end)>=2;

SELECT battle 
FROM outcomes o 
join ships s on o.ship=s.name
join classes c on s.class=c.class
WHERE c.numGuns<9 
GROUP BY battle
HAVING count(*)>=3 AND sum(CASE result WHEN 'ok' THEN 1 ELSE 0 END)>=2;
