--1
use movies;

select distinct title, year
from movie
left join starsin on movietitle=title and movieyear=year
where starname not like '%k%' and starname not like '%b%' and year<1982
order by year

--2
select title, length/60 as LengthInHours
from movie
where year=(select year from movie where title='Terms of Endearment') and (length<(select length from movie where title='Terms of Endearment') or length is null)

--3
select*
from movieExec 
where name in 
(select starname
from starsin
where movieyear<1984 
intersect
select starname
from starsin
where movieyear>1985)

--4
select title
from movie
where year<=(select min(year) 
			from movie 
			where incolor='y') and incolor='n' and studioname=(select studioname 
																from movie
																where year=(select min(year) from movie where incolor='y'))


select* from movie where year=1938

--5
select name, address
from studio
where name in (select name
				from studio
				left join movie on studioname=name
				left join starsin on movietitle=title and movieyear=year
				group by name
				having count(distinct starname) <5)


--с колко звезди е работило всяко студио
select name, count(distinct starname) as CountStars
from studio
left join movie on studioname=name
left join starsin on movietitle=title and movieyear=year
group by name
having count(distinct starname) >2


--6
use ships;
select name, launched
from ships
where class not like '%i%' and class not like '%k%'
order by launched

--7 
--колко японски/американски кораби са damaged в дадена битка
select battle--, count(ship) as CountShips
from outcomes
left join ships on name=ship
left join classes on classes.class=ships.class
where result='damaged' and country='USA'
group by battle
having count(ship)>=1

--8
select launched+1
from ships
where name='Rodney'

select country, avg(numguns) as AvgNumguns
from classes
group by country

select name, class
from ships
where launched=(select launched+1
				from ships
				where name='Rodney')
intersect
(select name, ships.class
from ships
left join classes on classes.class=ships.class
join (select country, avg(numguns) as AvgNumguns
	from classes
	group by country) as t1 on t1.country=classes.country
where numguns>=AvgNumguns)


--9
select c.class, max(launched), min(launched)
from classes c
right join ships on c.class=ships.class
where country='USA' 
group by c.class
having max(launched)-min(launched)<10


--10
select b.name, count(*)/count(distinct country)
from battles b 
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship
left join classes c on c.class=s.class
group by b.name

select b.name, c.country, count(*)
from battles b 
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship
left join classes c on c.class=s.class
group by b.name, c.country
order by b.name


--11
select country, count(distinct name) as CountShips
from classes c
left join ships s on s.class=c.class
group by country

select country, count(battle) as CountBattles
from classes c
left join ships s on s.class=c.class
left join outcomes o on o.ship=s.name
group by country

--ain't finished
select country, result, count(battle) as CountBattlesSunk
from classes c
left join ships s on s.class=c.class
left join outcomes o on o.ship=s.name
group by country, result
order by country

--12
use movies;
select starname, count(distinct name) as CountStudios
from starsin
join movie on movietitle=title and movieyear=year
join studio on studioname=name
group by starname

--13
select name, count(distinct studioname)
from moviestar
left join starsin on name=starname
left join movie on movietitle=title and movieyear=year
group by name

--14
use movies;
--в колко филми е участвала всяка звезда
select name--, count(movietitle) as CountMovies
from moviestar
left join starsin on starname=name
where movieyear>=1990
group by name
having count(movietitle)>=1

--15
use pc;
select product.model--, max(price) as MaxPrice
from product
join pc on pc.model=product.model
group by product.model
order by max(price)

--16
use ships;
--колко потънали американски кораба има всяка битка
select b.name, count(distinct s.name) as CountSunkAmericanShips
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship
left join classes c on c.class=s.class
where country='USA' and result='sunk'
group by b.name
having count(distinct s.name)>=1

--17
--колко кораба от всяка страна
select country, count(ships.name)
from classes
left join ships on ships.class=classes.class
group by country

--колко кораба във всяка битка
select b.name, c.country, count(s.name) as CountShipsPerBattleAndCountry
from battles b
left join outcomes o on o.battle=b.name
join ships s on s.name=o.ship
join classes c on c.class=s.class
group by b.name, c.country
having count(s.name)>=3
order by b.name

--18
--колко пуснати кораба има за всеки клас + да има поне един (или да има 0)
select c.class, count(s.name)
from classes c
left join ships s on s.class=c.class
group by c.class
having count(s.name)=0
--having count(name)>=1

--за всеки клас колко пуснати кораби след 1921 година има? + тези, които имат 0
select c.class, count(s.name) as ShipsLaunchedAfter1921--, min(launched), max(launched)
from classes c
left join ships s on s.class=c.class and launched>=1921
where c.class not in (select c.class--, count(s.name)
						from classes c
						left join ships s on s.class=c.class
						group by c.class
						having count(s.name)=0)
group by c.class
having count(s.name)=0


--19
select s.name, count(o.battle)
from ships s
left join outcomes o on o.ship=s.name and result='damaged'
group by s.name

select *
from outcomes
where result='damaged'

--20
--official
select c.class, count(o.ship) as CountWinners
from classes c
left join ships s on s.class=c.class
left join outcomes o on s.name=o.ship and result='ok'
where c.class in (select c.class--, count(name)
					from classes c
					left join ships s on s.class=c.class
					group by c.class
					having count(name)>3)
group by c.class


select class, count(ship)
from outcomes 
join ships on name=ship
where result='ok'
group by class

select c.class--, count(name)
from classes c
left join ships s on s.class=c.class
group by c.class
having count(name)>3

