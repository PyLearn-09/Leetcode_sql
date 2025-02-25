with schedule as (
select customer_id, customer_pref_delivery_date,order_date,
rank() over (partition by customer_id order by order_date) as rnk
from delivery
)
select 
round((sum(case when order_date = customer_pref_delivery_date then 1 else 0 end)/count(*))*100,2) as immediate_percentage
from schedule
where rnk = 1; 
