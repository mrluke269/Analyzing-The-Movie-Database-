with movies as (
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
    tagline,
    overview,
    original_language,
    mg.genre_id,
    mc.company_id,
    mct.country_code,
    ml.language_code,
    mk.key_id
from {{ ref('stg_movies__raw_movies') }} as m
left join {{ ref('movie_genre_bridge') }} as mg on m.id = mg.movie_id
left join {{ref('movie_company_bridge')}} as mc on m.id = mc.movie_id
left join {{ref('movie_country_bridge')}} as mct on m.id = mct.movie_id
left join {{ref('movie_language_bridge')}} as ml on m.id = ml.movie_id
left join {{ref('movie_key_bridge')}} as mk on m.id = mk.movie_id
)

select * from movies
