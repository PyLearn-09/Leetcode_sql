--calculating different percentage 
--1211. Queries Quality and Percentage

select query_name, 
round(coalesce(sum(rating/position)/Nullif(count(rating),0),0),2) as quality,
round(coalesce((sum(case when rating < 3 then 1 end)/nullif(count(*),0)*100),0),2) as poor_query_percentage
from queries 
group by query_name;



with quality as (
    select query_name,
    round(coalesce(sum(rating/position)/nullif(count(rating),0),0),2) as quality
    from queries
    group by query_name 
),
query_percentage as(
    select query_name, 
    round(coalesce(sum(case when rating<3 then 1 end)/nullif(count(rating),0),0)*100,2) as poor_query_percentage
    from queries
    group by query_name
)
select q.query_name, q.quality, qp.poor_query_percentage 
from quality q
join query_percentage qp
on q.query_name = qp.query_name;