with actors_raw as (
    select distinct
        c.value:id::string as actor_id,
        c.value:name::string as actor_name,
        c.value:gender::int as gender
    from {{ ref('stg_movies__raw_credit') }} rc,
    lateral flatten(input => rc.cast_json) as c
    where c.value:id is not null
),

-- Deduplicate by taking the most common gender value (or non-zero if available)
actors_deduped as (
    select 
        actor_id,
        actor_name,
        MAX(gender) as gender
    from actors_raw
    group by actor_id, actor_name
)

select 
    actor_id,
    actor_name,
    gender
from actors_deduped