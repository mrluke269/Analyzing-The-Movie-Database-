select
    c.movie_id,
    cj.value:id::string as actor_id,
    cj.value:character::string as character_name,  
    cj.value:order::int as cast_order,            
    cj.value:credit_id::string as credit_id      
from {{ ref('stg_movies__raw_credit') }} as c,
lateral flatten(input => c.cast_json) as cj
where c.movie_id is not null 