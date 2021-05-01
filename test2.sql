

use ships;
--����� ��������� � 25% �������� (bore) �� ���� �������, �� ����� ��� ���� ��� ������

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
--�� �� ������� ����, �� ��� �������� �� ���� ����� 
--����������� �� �� �������� ������ ����� ����� �� ������ ������, � ����� �� �� ��������� ������.

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

--������ ����� � ����� �� ��������� >=1 �����
select battle, count(ship)
from outcomes
group by battle

select distinct battle
from outcomes


