with raw_movies as(
    select * from {{ ref('stg_movies__raw_movies') }}
),

renamed as (
SELECT
    id as movie_id,
    title,
    release_date,
    budget,
    revenue,
    runtime,
    popularity,
    vote_average,
    vote_count,
    status
from raw_movies
)

select * from renamed
