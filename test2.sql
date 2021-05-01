

use ships;
--която увеличава с 25% калибъра (bore) на тези класове, от които има поне три кораба

select c.class
from classes c
join ships s on s.class=c.class
group by c.class
having count(s.name)>=3

begin transaction
update classes
set bore=bore+bore*0.25
where class in (select c.class
			from classes c
			join ships s on s.class=c.class
			group by c.class
			having count(s.name)>=3)

select* from classes
rollback transaction


--2
--Да се направи така, че при добавяне на нова битка 
--автоматично да се изтриват всички други битки от същата година, в които не са участвали кораби.

go
create trigger tr
on battles
after insert
as 
	delete 
	from battles
	where Year(date)=(select year(date) from inserted) and
		name not in (select distinct battle from outcomes)
go

--всички битки в които са участвали >=1 кораб
select battle, count(ship)
from outcomes
group by battle

select distinct battle
from outcomes


