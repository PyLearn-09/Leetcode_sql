-- 1934. Confirmation Rate

with result as (
select s.user_id as user_id,count(c.user_id) as count_check,
sum(case when c.action='confirmed' then 1 else 0 end) as test_sum
from signups s
left join confirmations c
on s.user_id = c.user_id
group by s.user_id
)
select r.user_id,
max(case when r.count_check >0 then round(r.test_sum/count_check,2) else 0 end) as confirmation_rate
from result r
group by r.user_id
order by confirmation_rate