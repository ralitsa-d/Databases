use ships;
go
CREATE TRIGGER tr5
ON Outcomes
AFTER INSERT, UPDATE
AS
 IF EXISTS (SELECT *
 FROM Inserted
 JOIN Ships ON ship = Ships.name
 JOIN Battles ON battle = Battles.name
 WHERE launched > YEAR(Battles.date))
 BEGIN
 RAISERROR('Error: ship is launched after the battle', 16, 10);
 -- ��� ���� ���� "�"
 ROLLBACK;
 END;
 go

 insert into outcomes
 values('Iowa', 'North Atlantic', 'sunk');

 SELECT * FROM Outcomes WHERE ship = 'Iowa';
 select* from ships where name='Iowa' -- ������ � ���� 1943
 select* from battles where name='North Atlantic' -- � ������ �� � �������� � �����, ����� � ���� 1941

 drop trigger tr5;


