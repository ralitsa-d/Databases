use movies;

--1
select title, year, name, address
from movie
join studio on studioname=name
where length>120

--2
select distinct studioname, starname
from movie
join starsin on movietitle=title and year=movieyear
order by studioname

--3
select distinct name
from movieexec
join movie on cert#=producerc#
left join starsin on title=movietitle and year=movieyear
where starname='Harrison Ford'

--4
select distinct name
from movie
join starsin on movietitle=title and year=movieyear
join moviestar on name=starname
where gender='F' and studioname='MGM'

--5
select title
from movie
join movieexec on producerc#=cert#
where name in
(select name
from movieexec
join movie on producerc#=cert#
where title='Star Wars')

--6
select name
from moviestar
left join starsin on starname=name
where movietitle is null

use pc;

--1
select p.maker, p.model, p.type
from product p
left join laptop on laptop.model=p.model
left join pc on p.model=pc.model
left join printer on p.model=printer.model
where laptop.code is null and pc.code is null and printer.code is null

use ships;

--1
select name, country, numguns, launched
from ships
left join classes on classes.class=ships.class

--2
select ship
from outcomes
left join battles on battle=name
where year(date)=1942

--допълнителни задачи по матриала до тук
select*
from movie
where title like '%Star%' and title like '%Trek%'
order by year DESC, title

select*-- movietitle, movieyear
from starsin
join moviestar on starname=name
where birthdate.year>=1970 and birthdate.year<=1980


use ships;
--1
select name, launched
from ships
where class=name

--2
use movies;
select*
from movie
where title like '%Star%' and title like '%Trek%'
order by year DESC, title

--3
select movietitle, movieyear
from starsin
join moviestar on name=starname
where year(birthdate)>=1970 and birthdate<='1980-07-01 00:00:00.000'

--4
use ships;
select*
from ships
join outcomes on ship=name
where name in (select distinct ship from outcomes) and (name like 'C%' or name like 'K%')

--5
select distinct country
from classes
join ships on classes.class = ships.class
join outcomes on name=ship and result='sunk'

--6
select distinct country
from classes
join ships on classes.class = ships.class
join outcomes on name=ship and (result='damaged' or result='ok')

--7
select classes.class
from classes 
left join ships on classes.class=ships.class and launched>1921
where name is null

--8
select class, country, bore*2.24 as BOREinCM
from classes
where numguns=6 or numguns=8 or numguns=10

--9
use ships;
select distinct c1.country
from classes c1
left join classes c2 on c1.country=c2.country
where c1.bore<>c2.bore


--10
select distinct country
from classes
where numguns>=all(select numguns from classes)

--11
use pc;
select pc.*
from pc
join product p on p.model=pc.model
where price<all(select price
				from laptop
				join product p1 on p1.model=laptop.model
				where p1.maker=p.maker)


--12
select pc.*
from pc
join product p on p.model=pc.model
where price<all(select price
				from laptop
				join product p1 on p1.model=laptop.model
				where p1.maker=p.maker)
and price<all(select price
				from printer
				join product p2 on p2.model=printer.model
				where p2.maker=p.maker)