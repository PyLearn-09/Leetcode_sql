-- 1661. Average Time of Process per Machine

SELECT machine_id,
ROUND((SUM(CASE WHEN activity_type ='start' THEN timestamp*(-1) ELSE timestamp END)*1/(SELECT COUNT(DISTINCT process_id))),3) as processing_time
from activity 
group by machine_id
order by processing_time DESC;