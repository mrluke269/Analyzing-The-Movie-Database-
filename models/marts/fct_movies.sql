with raw_movies as(
    select * from {{ ref('stg_movies__raw_movies') }}
),

renamed as (
SELECT
    id as movie_id,
    title,
    original_title,
    release_date,
    budget,
    revenue,
    runtime,
    popularity,
    vote_average,
    vote_count,
    status,
    original_language,
    mg.genre_id,
    mc.company_id,
    ma.actor_id,
    mcr.crew_id
from raw_movies as m
left join {{ ref('movie_genre_bridge') }} as mg on m.id = mg.movie_id
left join {{ref('movie_company_bridge')}} as mc on m.id = mc.movie_id
left join {{ref('movie_actor_bridge')}} as ma on m.id = ma.movie_id
left join {{ref('movie_crew_bridge')}} as mcr on m.id = mcr.movie_id
)

select * from renamed
