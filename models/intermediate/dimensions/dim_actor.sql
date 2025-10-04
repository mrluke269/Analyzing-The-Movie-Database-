with 
raw_cast as 
(select * from {{ ref('stg_movies__raw_credit') }}),
  
renamed as   
  (select distinct
    c.value['id']::string as actor_id,
    c.value['name']::string as actor_name,
    c.value['character']::string as character_name,
    c.value['gender']::int as gender,
    c.value['credit_id']::string as credit_id,
    c.value['order']::number as cast_order
  from raw_cast rc,
  lateral flatten(input => parse_json(rc.cast_json)) as c
)

select * from renamed
