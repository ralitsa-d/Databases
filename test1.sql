--1
use ships;
select b.name, s.name, count(*)
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship --and launched=
group by b.name, s.name
order by b.name


select b.name,  count(launched)
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship 
group by b.name, s.launched

--2
--всички японски кораби от даден клас, kolko koraba ima
select c.class, max(launched) as MaxLaunched, count(o.battle) as CountBattles
from classes c
left join ships s on s.class=c.class
left join outcomes o on o.ship=s.name
where country='Japan'
group by c.class
having count(s.name)>=2 and count(s.name)<=4

--3

--bitki w koito sa uchastwali stari korabi ot neiszwestni dyrvawi
select b.name, month(b.date) as Month
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship-- and launched>=year(b.date)
left join classes c on c.class=s.class-- and country is not null
where launched>=year(b.date)-4 and country is not null

select b.name, month(b.date) as Month
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship
left join classes c on c.class=s.class
except
(select b.name, month(b.date) as Month
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship and launched>=year(b.date)
left join classes c on c.class=s.class and country is not null)


select b.name, month(b.date) as Month
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship
left join classes c on c.class=s.class
except
(select b.name, month(b.date) as Month
from battles b
left join outcomes o on o.battle=b.name
left join ships s on s.name=o.ship-- and launched>=year(b.date)
left join classes c on c.class=s.class-- and country is not null
where launched>=year(b.date)-4 and country is not null
)


select* from battles


--4
select class, numguns
from classes
where country='Japan' and class not like '%k%' and (displacement<10000 or displacement>20000)
order by numguns, class




