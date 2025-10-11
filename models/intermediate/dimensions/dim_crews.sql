with 
raw_credit as 
(select * from {{ ref('stg_movies__raw_credit') }}),
  
renamed as   
  (select distinct
    c.value['id']::string as crew_id,
    c.value['name']::string as crew_name,
    c.value['gender']::int as gender
  from raw_credit rc,
  lateral flatten(input => parse_json(rc.crew_json)) as c
)

select * from renamed