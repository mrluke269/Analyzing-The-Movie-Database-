-- Best revenue by genre
select
    dg.genre_name,
    sum(m.revenue) as total_revenue
from {{ref("fct_movies")}} as m 
left join {{ref("movie_genre_bridge")}} as gb on m.movie_id = gb.movie_id
left join {{ref("dim_genres")}} as dg on gb.genre_id = dg.genre_id
group by 1
order by total_revenue desc