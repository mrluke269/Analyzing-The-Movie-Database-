with 
raw_cast as 
(select * from {{ ref('stg_movies__raw_credit') }}),
  
renamed as   
  (select distinct
    c.value['id']::string as actor_id,
    c.value['name']::string as actor_name,
    c.value['gender']::int as gender
  from raw_cast rc,
  lateral flatten(input => parse_json(rc.cast_json)) as c
)

select * from renamed
