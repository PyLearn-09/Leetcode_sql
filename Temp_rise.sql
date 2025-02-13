-- 197. Rising Temperature

select w1.id, w2.id, w1.recordDate as w1_date, w2.recordDate as w2_date, w1.temperature as w1_temp,
w2.temperature as w2_temp
from weather w1
join weather w2
on w1.recordDate = w2.recordDate + Interval 1 day