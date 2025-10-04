with raw_movies as(
    select * from {{ ref('stg_movies__raw_movies') }}
),

renamed as (
SELECT
    {{ dbt_utils.generate_surrogate_key(['id']) }} AS movie_key,
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
