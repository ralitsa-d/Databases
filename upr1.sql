use movies;
select address
from studio
where name='MGM'

select BIRTHDATE
from moviestar
where name='Sandra Bullock'

select starname
from starsin
where movietitle like '%Empire%' and movieyear=1980

select name
from MOVIEEXEC
where networth>10000000

select name
from moviestar
where gender='M' or address LIKE '%way%'

use pc;
select model,speed as MHz, hd as GB
from pc
where price<1200

select model, price*1.1 as priceInEuro
from laptop
order by price

select model, ram, screen
from laptop
where price*1.1>1000

select * 
from printer

select *
from printer
where color='y'

select model, speed, hd
from pc
where (cd='12x' or cd='16x') and price<2000


--rate=speed+ram+10*screen
select code, model, speed+ram+10*screen as rate
from laptop
order by rate, code

use ships;

select class, country
from classes
where numguns<10

select name as shipName
from ships
where launched<1980

select ship, battle
from outcomes
where result='sunk'

select name
from ships
where name=class

select name
from ships
where name like 'R%'

select name
from ships
where name like '% %' and name not like '% % %'