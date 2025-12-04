-- 05_average_interest_rate_per_city.sql

select 
    round(avg(lna.interest_rate), 2) as avg_interest_rate
    , cl.city
from loans lna 
inner join loan_applications lap 
    on lap.application_id = lna.application_id 
inner join clients cl 
    on cl.client_id = lap.client_id
group by cl.city
order by cl.city
