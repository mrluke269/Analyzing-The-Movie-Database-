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

select * from renamed;

-- In your fct_movies.sql
renamed as (
    SELECT
        id as movie_id,
        title,
        release_date,
        COALESCE(budget, 0) as budget,  -- Convert nulls to 0
        COALESCE(revenue, 0) as revenue,  -- Convert nulls to 0
        runtime,  -- OK to be null for unreleased movies
        COALESCE(popularity, 0) as popularity,
        COALESCE(vote_average, 0) as vote_average,
        COALESCE(vote_count, 0) as vote_count,
        status
    from raw_movies
)
