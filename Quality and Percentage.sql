--calculating different percentage 
--1211. Queries Quality and Percentage

select query_name, 
round(coalesce(sum(rating/position)/Nullif(count(rating),0),0),2) as quality,
round(coalesce((sum(case when rating < 3 then 1 end)/nullif(count(*),0)*100),0),2) as poor_query_percentage
from queries 
group by query_name;