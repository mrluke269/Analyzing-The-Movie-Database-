-- Best revenue by genre
select
    dg.genre_id,
    dg.genre_name,
    sum(m.revenue) as total_revenue,
    count(distinct m.movie_id) as total_movies,
    avg(m.revenue) as avg_revenue_per_movie,
    sum(m.revenue - m.budget) as total_profit,
    avg(m.vote_average) as avg_rating
from {{ref("fct_movies")}} as m 
inner join {{ref("movie_genre_bridge")}} as gb on m.movie_id = gb.movie_id
inner join {{ref("dim_genres")}} as dg on gb.genre_id = dg.genre_id
group by 1,2
order by 3 desc
