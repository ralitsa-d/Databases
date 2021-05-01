use movies;
--1
select name
from moviestar
where gender='M'
INTERSECT
select starname
from starsin
where movietitle='Terms of Endearment'

--по-добър метод
select name
from moviestar
join starsin on starname=name
where gender='M' and movietitle='Terms of Endearment'

--2
select starname
from movie
join starsin on movietitle=title
where studioname='MGM' and movieyear='1995'

--3
select distinct name
from movieexec
join movie on producerc#=cert#
where studioname='MGM'

--4
select title
from movie
where length > (select length
				from movie
				where title='Star Wars')


use pc;

--1
select distinct maker, speed
from laptop
join product on laptop.model=product.model
where hd>9

--2
(select product.model, price
from product 
join pc on product.model=pc.model
where maker='B'

UNION

select product.model, price
from product
join laptop on laptop.model=product.model
where maker='B'

UNION

select product.model, price
from product
join printer on printer.model=product.model
where maker='B')
order by price DESC

--3

select distinct p1.hd
from pc p1
join pc p2 on p1.hd=p2.hd and p1.code<>p2.code

--4
select distinct p1.model, p2.model
from pc p1
join pc p2 on p1.speed=p2.speed and p1.ram=p2.ram
where p1.model<p2.model

--5
select *
from pc
where speed >500

select*
from product
join pc on product.model=pc.model
where speed>500

select distinct *
from pc p1
join pc p2 on p1.model=p2.model
where p1.speed>500 and p2.speed>500


use ships;

--1
select name
from classes
join ships on classes.class=ships.class
where displacement>35000

--2
select name, displacement, numguns
from classes
join (select *
		from ships
		join outcomes on ship=name
		where battle='Guadalcanal') as NEWTABLE on classes.class=NEWTABLE.class

--3
select distinct c1.country
from classes c1
join classes c2 on c1.country=c2.country
where (c1.type='bb' and c2.type='bc')

--4
select o1.ship
from outcomes o1
join battles b1 on o1.battle=b1.name
join outcomes o2 on o1.ship=o2.ship
join battles b2 on o2.battle=b2.name
where o1.result='damaged' and b1.date<b2.date
