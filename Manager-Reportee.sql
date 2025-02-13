-- 570. Managers with at Least 5 Direct Reports
select  e.name 
from employee e
join employee et 
on et.managerId=e.id
group by e.name, e.id
having count(et.id) >=5;
