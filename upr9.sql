create database test
go
use test
go

create table product(
	maker char(1),
	model char(4),
	type varchar(7)
);

create table printer(
	code int,
	model char(4),
	color char(1) default 'n',
	price decimal(9, 2)
);

create table classes(
	class varchar(50),
	type char(2)
);

insert into product
values ('A', '1000', 'pc'),
		('B', '1001', 'laptop'),
		('A', '1002', 'printer'),
		('C', '1003', 'pc');

insert into printer
values (1, '1002', 'n', 399.90),
		(2, '1004', 'y', 599.90);

insert into classes
values ('Nikelson', 'bc'),
		('Bismark', 'bb');

insert into printer(code, model)
values (3, '1005')
-- за да се види, че на color се появява стойността, която сме задали като default-на

select* from product
select* from printer
select* from classes

alter table classes
add bore float

select* from classes

update classes
set bore=15.6
where class='Bismark'
update classes
set bore=17.1
where class='Nikelson'

alter table Classes
drop column bore

alter table printer
drop column price

select* from printer

drop table product
select* from product
drop table printer
select* from printer
drop table classes --само тази не съм execute-нала
select* from classes

Use master
go
drop database test
go