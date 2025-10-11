SELECT distinct
  ct.VALUE:"iso_3166_1"::string AS country_code,
  ct.VALUE:"name"::string AS country_name
FROM {{ ref('stg_movies__raw_movies') }},
LATERAL FLATTEN(INPUT => PARSE_JSON(production_countries)) AS ct
