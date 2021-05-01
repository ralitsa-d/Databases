use movies;
--1a
begin transaction

alter table movie
add constraint unique_length UNIQUE(length);

rollback transaction

--1b

/*select name, length, count(*)
from studio
left join movie on studioname=name
group by name, length
order by name*/

alter table movie
add constraint unique_studio_length UNIQUE(studioname, length)

--2
alter table movie 
drop constraint unique_studio_length

--3a
create database university
go
use university
go

create table students(
	fn int primary key check(fn>=0 and fn <=99999) not null, 
	name VARCHAR(100) not null, 
	egn char(10) unique not null,
	email VARCHAR(100) unique not null, 
	birthdate date not null, 
	acceptance date not null, 
	constraint at_least_18_years_after_birth check(datediff(year, birthdate, acceptance)>=18)
);

alter table students
drop constraint at_least_18_years_after_birth

alter table students
add constraint at_least_18_years_after_birth check(datediff(year, birthdate, acceptance)>=18)

insert into students
values(81888, 'Ivan Ivanov', '9001012222', 'ivan@gmail.com', '1990-01-01', '2009-01-10');

select* from students

--3b
alter table students
add constraint email_valid check(email like '%_@%_.%_');

update students set email = 'aaaa';

create table courses
(
	id int identity primary key,
	name varchar(50) not null
);

insert into courses(name) values('DB');
insert into courses(name) values('OOP');
insert into courses(name) values('Android');
insert into courses(name) values('iOS');
select * from courses;

create table StudentsIn(
	student_fn int refer
	idCourse int 
);