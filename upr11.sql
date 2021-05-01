use movies;
--1
go
create view v_actresses
as
	select name, birthdate
	from moviestar
	where gender='F';
go

--2
go
create view v_count_movies
as
	select name, count(movietitle) as CountMovies
	from moviestar left join starsin on starname=name
	group by name;
go

--3. горните изгледи позволяват ли модификации?

use pc;
--1
go
create view v_products
as
	select code, model, price
	from laptop
	union all
	select code, model, price
	from pc
	union all
	select code, model, price
	from printer
go

--2, 3
go
alter view v_products 
as
	select code, model, price, 'laptop' as type, speed
	from laptop
	union all
	select code, model, price, 'pc' as type, speed
	from pc
	union all
	select code, model, price, 'printer' as type, null
	from printer
go

use ships;
--1
go
create view BritishShips
as
	select c.class, type, numguns, bore, displacement, launched
	from classes c join ships s on c.class=s.class
	where country='Gt.Britain'
go

--2
select numguns, displacement
from BritishShips
where type='bb' and launched<1919

--3
select numguns, displacement
from classes c join ships s on s.class=c.class
where country='Gt.Britain' and launched<1919 and type='bb'

--4
--най-тежките класове кораби (displacement)
select avg(MaxDisplacement)
from 
(select max(displacement) as MaxDisplacement
from classes
group by country) as table1

--5
--всички потънали кораби по битки 
select*
from outcomes
where result='sunk'
order by battle

go
create view SunkShips
as
	select battle, ship
	from outcomes
	where result='sunk'
go


--6
insert into SunkShips(battle, ship)
values ('Guadalcanal', 'California')

begin transaction
alter table outcomes 
add result varchar(20) default 'unlisted'
rollback transaction

--7
go
create view v_classes_9 as
select class
from classes
where numguns>=9
with check option
go

begin transaction
update v_classes_9
set numguns=5
where class='Iowa'
rollback transaction

--8
drop view v_classes_9
go
alter view v_classes_9 as
select class
from classes
where numguns>=9

go
begin transaction
update v_classes_9
set numguns=5
where class='Iowa'
rollback transaction

delete from outcomes where result is null;
drop view SunkShips;
drop view v_classes_9;


--9





