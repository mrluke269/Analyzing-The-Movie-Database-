SELECT distinct
  c.VALUE:"id"::string AS company_id,
  c.VALUE:"name"::string AS company_name
FROM {{ ref('stg_movies__raw_movies') }},
LATERAL FLATTEN(INPUT => PARSE_JSON(production_companies)) AS c