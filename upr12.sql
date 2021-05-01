use movies;
--1
insert into moviestar(name) values('Bruce Willis');
select* from moviestar
go 
create trigger tr1
on movie
after insert
as 
	insert into starsin(movietitle, movieyear, starname)
	select title, year, 'Bruce Willis'
	from Inserted
	--join starsin on movietitle=title and movieyear=year
	where title like '%save%' and title like '%world%'
go

drop trigger tr1

insert into movie(title, year) values('Save the planet', 2001);
select* from movie
select* from starsin

delete from starsin where starname='Bruce Willis'
delete from movie where title='Save the planet'
delete from moviestar where name='Bruce Willis'




--2
go
create trigger tr2
on movieexec
instead of insert, update, delete
as 
	if (select avg(networth)
	from movieexec)<500000 
	begin 
		raiserror('Error: Average networth cannot be < 500000', 16, 10);
		rollback;
	end;
go

drop trigger tr2;

insert into movieexec(cert#, name, address, networth) values(111, 'Test', 'Test-addr', 200)

select avg(networth)
from movieexec

select* from movieexec

delete from movieexec where cert#=111



--3
go
create trigger tr3
on movieexec
instead of delete
as
begin
	update movie
	set producerc#=null
	where producerc# in (select cert# from deleted)
		--and producerc# not in (select cert# from movieexec)

	delete from movieexec
    where cert# in (select cert# from deleted);
end;
go

drop trigger tr3;

select* from movie

begin transaction
delete from movieexec where producerc#=222
select* from movie
rollback transaction



--4
go
create trigger tr4
on starsin
instead of insert
as 
begin
	insert into moviestar(name)
	select distinct starname from inserted
	where starname not in (select name from moviestar)

	insert into movie(title, year)
	select distinct movietitle, movieyear from inserted
	where not exists (select* from movie where title=movietitle and year=movieyear)

	insert into starsin
	select*
	from inserted
end;
go

drop trigger tr4;

insert into starsin values('tralala', '1995', 'Bruce Almighty')

select* from starsin
select* from moviestar
select* from movie
delete from starsin where movietitle='tralala'
delete from moviestar where name='Bruce Almighty'
delete from movie where title='tralala'


use pc;
--1
go
create trigger tr2_1
on laptop
after delete
as
	insert into pc
	select code+100, '1121', speed, ram, hd, '52x', price 
	from deleted
	--join product on product.model=deleted.model
	--where maker='D'
go

drop trigger tr2_1

--2
go
create trigger tr2_2
on pc
instead of update
as
	not exist (select price from pc where price<deleted.price)
go


--3
go
create trigger tr2_3
on product
instead of insert
as 
	if exists (select*
				from product p1
				join product p2 on p1.maker=p2.maker
				where (p1.type='pc' and p2.type='printer') or (p1.type='printer' and p2.type='pc'))
	begin 
		raiserror('Error', 16, 10);
		rollback;
	end;	
go

drop trigger tr2_3

begin transaction
insert into product
values('D', 3000, 'PC')
rollback transaction

--4
go
create trigger tr2_4
on product
instead of insert
	if (select type from inserted)='pc' and (select maker from inserted) not in (select maker from product 
																				join laptop on laptop.model=product.model
																				where hd>=hd...)

	if exists(select*
				from product p1
				join product p2 on p1.maker=p2.maker
				left join laptop on p2.model=laptop.model
				where p1.type='pc' and p2.type='laptop' and laptop.speed>=(select speed from pc join inserted i on i.model=pc.model))
go

--5
go
create trigger tr2_5
on laptop
instead of update, insert, delete
as
	if(select avg(price)
		from laptop
		join product p on p.model=laptop.model
		group by maker) >1000
	begin 
		raiserror('Error', 16, 10);
		rollback;
	end;
go

drop trigger tr2_5;

select avg(price)
from laptop
join product p on p.model=laptop.model
group by maker

begin transaction
update product
set maker='A'
select avg(price)
from laptop
join product p on p.model=laptop.model
group by maker
rollback transaction

--6
go
create trigger tr2_6
on laptop
after insert, update
as 
	if exists(select L.price-p.price as LPdiff
		from laptop l, pc p
		where l.ram>p.ram)<=0
	begin
		raiserror('Error', 16, 10);
		rollback;
	end;
go

drop trigger tr2_6;

use pc;
select l.ram as Lram, p.ram as PCram, l.price as Lprice, p.price as Pprice
from laptop l, pc p
where l.ram>p.ram

select l.model as Lmodel, p.model as Pmodel, L.price-p.price
from laptop l, pc p
where l.ram>p.ram

select L.price-p.price as LPdiff
from laptop l, pc p
where l.ram>p.ram

select* from laptop
insert into laptop(code, model, speed, ram, hd, price, screen)
values(7, 3001, 450, 128, 4, 200, 11)


--7
select* from printer

go
create trigger tr2_7
on printer
instead of insert
as
	if exists(select* from inserted where type !='Matrix')
	insert into printer
	select code, model, color, type, price from inserted
	else if exists (select* from inserted where type='Matrix' and color='y')
	begin
		raiserror('Error', 16, 10)
		rollback;
	end;
go

drop trigger tr2_7;

BEGIN TRANSACTION
insert into printer
values(8, 3001, 'y', 'Matrix', 430)
select* from printer
ROLLBACK TRANSACTION


select* from printer

use ships;
--1
go
create trigger tr3_1
on classes
instead of insert
as
	if(select displacement from inserted)>35000
	insert into classes
	select class, type, country, numguns, bore, 35000 from inserted
go

drop trigger tr3_1;

begin transaction
insert into classes
values('Test', 'bc', 'Bulgaria', 9, 15, 46000)
select* from classes
rollback transaction

--2
go
create view ShipsCount
as
	select classes.class as NameOfClass, count(*) as CountShips
	from classes join ships on ships.class=classes.class
	group by classes.class
go

select* from ShipsCount

go 
create trigger tr3_2
on ShipsCount
instead of delete
as 
	delete 
	from classes
	where class=(select NameOfClass from deleted);

	delete 
	from ships
	where class=(select NameOfClass from deleted);
go

drop trigger tr3_2;

begin transaction
delete from ShipsCount
where NameOfClass ='Iowa'
select* from SHipsCount
select*from classes
select* from ships
rollback transaction;


--3
go
create trigger tr3_3
on ships
instead of insert, update
as
	if exists(select c.class
			from classes c
			join ships s on c.class=s.class
			group by c.class
			having count(s.name)>2)
	begin
		raiserror('Error', 16, 10);
		rollback;
	end;
go

drop trigger tr3_3;

select c.class, count(s.name)
		from classes c
		join ships s on c.class=s.class
		group by c.class

begin transaction
insert into ships 
values('Test', 'Tennessee', 1920)
select* from ships;
rollback transaction;

select* from ships;

--4
go
create trigger tr3_4
on outcomes 
instead of insert
as
	if (select ship 
		from inserted) in (select name
							from ships
							join classes c on c.class=ships.class
							where numguns<9) and
		(select battle
		 from inserted) in (select distinct battle
							from outcomes o
							join ships s on s.name=o.ship
							join classes c on c.class=s.class
							where numguns>=9)
	begin
		raiserror('Error', 16, 10)
		rollback;
	end;
go

drop trigger tr3_4;

select* from outcomes
select* from classes
select* from ships

begin transaction
insert into outcomes
values('Haruna', 'North Atlantic', 'damaged');
select* from outcomes;
rollback transaction;

select *
from outcomes o
join ships s on s.name=o.ship
join classes c on c.class=s.class
join outcomes o1 on o.ship=o1.ship

select o1.ship, o2.ship
from outcomes o1, outcomes o2
where o1.battle=o2.battle 
		and o1.ship!=o2.ship and 
		o1.ship in (select name from ships
					join classes on classes.class=ships.class
					where numguns>=9) and
		o2.ship in (select name from ships
					join classes on classes.class=ships.class
					where numguns>=9)

--koi sa bitkite w koito ima korabi s numguns>9
select distinct battle
from outcomes o
join ships s on s.name=o.ship
join classes c on c.class=s.class
where numguns>=9


--5
select * from outcomes

go
create trigger tr3_5_1
on outcomes
instead of insert
as
	if(select ship from inserted) in (select ship from outcomes where result='sunk') and
		(select date 
		from inserted
		join battles on battle=name)<any(select date
											from battles
											join outcomes on battle=name
											where ship in(select ship from inserted)) 
	begin
		raiserror('Error', 16, 10)
		rollback;
	end;
go


drop trigger tr3_5_1

begin transaction
insert into outcomes
values('Bismark', 'Surigao Strait', 'ok');
--select* from outcomes;
rollback transaction;

select* from battles
select* from outcomes

go
create trigger t
on outcomes
after insert, update
as
if exists  (select *
            from outcomes o1
            join battles b1 on o1.battle = b1.name
            join outcomes o2 on o1.ship = o2.ship
            join battles b2 on o2.battle = b2.name
            where o1.result = 'sunk'
            and b1.date < b2.date)
begin
    raiserror('...', 16, 10);
    rollback;
end;
go

