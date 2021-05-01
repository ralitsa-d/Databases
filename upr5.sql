use pc;
--1
select avg(speed) as AverageSpeed
from pc

select speed from pc;

--2
select maker, avg(screen) as AVGscreen
from product
left join laptop on laptop.model = product.model
group by maker

select maker, screen
from product
left join laptop on laptop.model=product.model

--3
select avg(speed) as AVGspeed
from laptop
where price>1000

--4
select avg(price) as AVGprice
from product
left join pc on pc.model=product.model
where maker='A'

select maker, avg(price) as AVGprice
from product
left join pc on pc.model=product.model
group by maker

--5
select avg(AVGprice) as AvgPriceWhereMakerIsB
from 
(select maker, avg(price) as AVGprice
from product
left join laptop on laptop.model=product.model
group by maker
union
(select maker, avg(price) as AVGprice
from product
left join pc on pc.model=product.model
group by maker)) as newTable
where maker='B'

--6
select speed, avg(price) as AVGprice
from pc
group by speed

--7
select maker
from
(select maker, count(pc.model) as CountModels
from product
left join pc on pc.model=product.model
group by maker
having count(pc.model) >=3) as table1

--8
select maker
from product
left join pc on pc.model=product.model
where price = (select max(price) from pc)

--9
select avg(price) as AVGprice
from pc
group by speed
having speed > 800

--10
select maker, avg(hd) as AVGhd
from product
left join pc on pc.model=product.model
group by maker
having maker in 
(select distinct maker
from product
where type='Printer')

--11
select screen, (max(price) - min(price)) as difference
from laptop
group by screen

use ships;

--1
select count(distinct class) as CountClasses
from ships

--2
select name, avg(numguns) as AVGnumguns
from classes
left join ships on classes.class=ships.class
where name is not NULL
group by name

--3
select class, min(launched) as MinLaunched, max(launched) as MaxLaunched
from ships
group by class

--4
select class, count(*) as CountSunk
from ships
left join outcomes on ship=name
where result='sunk'
group by class

--5
select class, count(ship)
from ships
left join outcomes on ship=name
where result='sunk'
group by class


select class--, count(*) as CountLaunched
from ships
left join outcomes on ship=name
group by class
having count(*)>=4


select result, count(*) as NumShips
from outcomes
group by result
having result='sunk'

--5 official
select class, count(*) as CountSunk
from outcomes
left join ships on ship=name
where result='sunk' and class in (select class
									from ships
									left join outcomes on ship=name
									group by class
									having count(*)>=4)
group by class

--6
select country, avg(displacement) as AVGdisplacement
from classes
group by country


--допълнителни задачи
--1
use movies;
select starname, count(studioname) as CountStudios
from starsin
left join movie on title=movietitle and year=movieyear
group by starname
 
--2
select starname, count(*) as CountMovies
from starsin
left join movie on title = movietitle and year = movieyear 
where year>=1990
group by starname
having count(*)>=3

--3
use pc;
select model, max(price) as MAXprice
from pc
group by model
order by MAXprice

--4
use ships;

--брой на потъналилте американски кораби
select country, count(*) as CountSunk
from classes
left join ships on ships.class = classes.class
right join outcomes on name=ship
where result='sunk' and battle in 
	(select battle --, count(result) as CountResult, count(country) as CountCountry
	from outcomes
	left join ships on name=ship
	right join classes on classes.class=ships.class
	where result='sunk' and country='USA'
	group by battle)
group by country
having country='USA'

--Битките, в които има поне един потънал американски кораб
select battle, count(result) as CountResult, count(country) as CountCountry
from outcomes
left join ships on name=ship
right join classes on classes.class=ships.class
where result='sunk' and country='USA'
group by battle

--official
select battle, count(*) as CountSunkFromUSA
from outcomes
left join ships on name=ship
right join classes on classes.class=ships.class
where result='sunk' and country='USA'
group by battle


--5
use ships;
select battle, country, count(*) as CountShipsFromOneAndTheSameCountry
from outcomes 
left join ships on ship=name
right join classes on classes.class=ships.class
group by country, battle
having count(*) >=3

--6
--класовете, за които има пуснат кораб (launched) (поне един) except класовете, за които има пуснат кораб след 1921 г.
select classes.class
from classes
left join ships on classes.class= ships.class
group by classes.class
having count(*) >=1
except
(select classes.class
from classes
left join ships on classes.class= ships.class
where launched>=1921
group by classes.class)

--7
select name, result, count(battle)
from ships
left join outcomes on name=ship
group by name, result

--8
select classes.class, count(name) as CountWinner
from classes
left join ships on ships.class=classes.class
right join outcomes on ship=name
where result='ok' and classes.class in (select classes.class
											from classes
											left join ships on ships.class=classes.class
											group by classes.class
											having count(name)>=3)
group by classes.class

--за всеки клас, броя победители
select classes.class, count(name) as CountWinner
from classes
left join ships on ships.class=classes.class
right join outcomes on ship=name
where result='ok'
group by classes.class

--9
select battles.name, battles.date, count(name) as CountShips
from battles
left join outcomes on battles.name=battle
group by battles.name, battles.date


select battles.name, battles.date, count(name) as CountSunk
from battles
left join outcomes on battles.name=battle
where result='sunk'
group by battles.name, battles.date

select battles.name, battles.date, count(name) as CountDamaged
from battles
left join outcomes on battles.name=battle
where result='damaged'
group by battles.name, battles.date

select battles.name, battles.date, count(name) as CountOk
from battles
left join outcomes on battles.name=battle
where result='ok'
group by battles.name, battles.date

use ships;
select battles.name, battles.date, case
									when result='sunk' then 'SUNK'--count(result)
									when result='damaged' then 'DAMAGED'--count(result)
									when result='ok' then 'OK'--count(result)
								end as CountShipsStatus, count(*) as CountShips
from battles
left join outcomes on battles.name=battle
group by result, battles.name, battles.date

--official
use ships;
select battles.name, battles.date, sum (case result
											when 'sunk' then 1
											else 0
										end) as CountSunk, 
									sum (case result
											WHEN 'damaged' then 1
											else 0
										end) as CountDamaged,
									sum (case result
											when 'ok' then 1
											else 0
										end) as CountOk
from battles
left join outcomes on battle=name
group by battles.name, battles.date

--10
