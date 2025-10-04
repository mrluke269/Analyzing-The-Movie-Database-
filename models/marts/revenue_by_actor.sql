-- Revenue by actor
select
    da.actor_name,
    sum(m.revenue) as total_revenue,
    count(distinct m.movie_id) as total_movies,
    avg(m.revenue) as avg_revenue_per_movie,
    sum(m.revenue - m.budget) as total_profit,
    avg(m.vote_average) as avg_rating
from {{ref("fct_movies")}} as m 
left join {{ref("movie_actor_bridge")}} as ab on m.movie_id = ab.movie_id
left join {{ref("dim_actor")}} as da on ab.actor_id = da.actor_id
group by 1
order by 2 desc