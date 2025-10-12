
with 
raw_credit as (
    select * from {{ ref('stg_movies__raw_credit') }}
),

crew_raw as (
    select distinct
        c.value:id::string as crew_id,
        c.value:name::string as crew_name,
        c.value:gender::int as gender
    from raw_credit rc,
    lateral flatten(input => parse_json(rc.crew_json)) as c
    where c.value:id is not null
),

-- Treated Deduplicated
crew_deduped as (
    select 
        crew_id,
        crew_name,
        -- Take non-zero gender if exists, otherwise take the max
        -- This prioritizes actual gender values (1 or 2) over "not specified" (0)
        MAX(gender) as gender
    from crew_raw
    group by crew_id, crew_name
)

select 
    crew_id,
    crew_name,
    gender
from crew_deduped