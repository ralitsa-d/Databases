--1
use movies;
begin transaction
insert into moviestar(name, birthdate)
values('Nicole Kidman', '1967-07-20')
select* from moviestar
rollback transaction
select* from moviestar

--2
begin transaction
delete
from movieexec
where networth <125000000
select* from movieexec;
rollback transaction 
select* from movieexec;

--3
begin transaction
insert into moviestar(name, birthdate)
values('Nicole Kidman', '1967-07-20')
select* from moviestar
select *
from moviestar
where address is null
rollback transaction

begin transaction
delete
from moviestar
where address is null
select* from moviestar
rollback transaction

--4
begin transaction
update movieexec
set movieexec.name= 'Pres. '+movieexec.name
where movieexec.name in
(select movieexec.name
from movieexec
left join movie on cert#=producerc#
where studioname is not null)
select* from movieexec
rollback transaction;

select* from movieexec

use pc;
--1

begin transaction
insert into product
values('C', 1100, 'PC')
select* from product

insert into pc
values(12, 1100, 2400, 2048, 500, '52x', 299)
select* from pc


--2
delete 
from pc
where model=1100

delete 
from product
where model=1100

select* from product
select* from pc
rollback transaction;


--3
begin transaction 
insert into laptop(code, model, speed, ram, hd, price, screen)
select code, model, speed, ram, hd, price+500, 15
from pc

select* from laptop
rollback transaction

--4
select* from laptop
begin transaction 
delete 
from laptop
where model in
(select laptop.model
from laptop 
left join product on laptop.model=product.model
where maker not in
(select distinct maker
from product
where type='Printer'))

select* from laptop
rollback transaction

--5
select* from product
begin transaction
update product
set maker='A'
where maker='B'
select* from product
rollback transaction

--6
select* from pc;
begin transaction
update pc
set price=price/2, hd=hd+20
select* from pc
rollback transaction;

--7
select* from laptop
begin transaction
update laptop
set screen=screen+1
where model in
(select laptop.model
from product
join laptop on laptop.model=product.model
where maker='B')
select* from laptop
rollback transaction 

use ships;
--1
begin transaction
select* from ships

insert into classes
values('Nelson', 'bb', 'Gt. Britain', 9, 16, 34000)

insert into ships
values('Nelson', 'Nelson', 1927), ('Rodney', 'Nelson', 1927)

select* from ships
rollback transaction

--2
begin transaction
select * from ships
delete 
from ships
where name in
(select name
from ships
left join outcomes on ship=name
where result='sunk')
select * from ships
rollback transaction 

--3
begin transaction
select* from classes
update classes
set bore=bore*2.4, displacement=displacement*1.1
select* from classes
rollback transaction

--4
begin transaction 
select* from classes
delete 
from classes
where class in
(select classes.class
from classes
left join ships on ships.class=classes.class
group by classes.class
having count(*)<=3)
select* from classes
rollback transaction


--5
begin transaction
select* from classes
update classes
set bore=(select bore from classes where class='Bismarck'), 
	displacement=(select displacement from classes where class='Bismarck')
where class='Iowa'
select* from classes
rollback transaction
