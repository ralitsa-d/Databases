use movies;

--1
select name
from movieexec
where networth>10000000 and name in (select name from moviestar where gender='F')

--2
select name
from moviestar
where name not in (select name from movieexec)

use pc;
--1
select maker
from product
where type='PC' and model in 

(select model
from pc
where speed>500)

--2
select*
from laptop
where speed<=ALL
(select speed
from pc)

--3
select model
from

(select model, price
from printer
where price>=ALL(select price from printer)
union
select model, price
from pc
where price>=ALL(select price from pc)
union
select model, price
from laptop 
where price>=ALL(select price from laptop)) as newtable

where price>=ALL(select price from (select model, price
									from printer
									where price>=ALL(select price from printer)
									union
									select model, price
									from pc
									where price>=ALL(select price from pc)
									union
									select model, price
									from laptop 
									where price>=ALL(select price from laptop)) as newtable ) 

--4
select maker
from product
join 

(select*
from (select*
from printer
where color='y') newtable1
where price<=ALL(select price from (select* from printer where color='y') as newtable)) as newtable2 on product.model=newtable2.model

--5
select maker
from 
(select*
from
(select*
from pc
where ram<=ALL(select ram from pc)) as nawtab1
where speed>=ALL(select speed from (select*
									from pc
									where ram<=ALL(select ram from pc)) as nawtab2)) as newtab3

join product on newtab3.model=product.model

use ships;

--1
select country
from classes
where numguns>=ALL(select numguns from classes)

--2
select distinct name
from classes
join ships on classes.class=ships.class
where bore=16

--3

select battle
from outcomes
where ship in (select name
				from ships 
				where class='Kongo') 

--втори начин
select battle
from ships
join outcomes on ship=name
where class='Kongo'

--4
select distinct bore
from classes
order by bore

--мега каруцарския начин.. и е неправилен
select country
from ships
join classes on classes.class=ships.class
where bore=14 and numguns>=ALL(select numguns from ships join classes on classes.class=ships.class where bore=14)
union
select country
from ships
join classes on classes.class=ships.class
where bore=15 and numguns>=ALL(select numguns from ships join classes on classes.class=ships.class where bore=15)
union
select country
from ships
join classes on classes.class=ships.class
where bore=16 and numguns>=ALL(select numguns from ships join classes on classes.class=ships.class where bore=16)
union
select country
from ships
join classes on classes.class=ships.class
where bore=18 and numguns>=ALL(select numguns from ships join classes on classes.class=ships.class where bore=18)

--правилен начин
select name
from ships s
join classes c on s.class = c.class
where numguns >= all (select numguns
				from classes c2
				where c2.bore = c.bore);