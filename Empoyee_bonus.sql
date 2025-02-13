-- 577. Employee Bonus
select e.name, b.bonus
from employee e 
left join bonus b 
on b.empID = e.empID
where b.bonus <1000 OR  b.bonus is null;