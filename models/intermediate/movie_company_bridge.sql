SELECT
  m.id::string AS movie_id,
  c.VALUE:"id"::string AS company_id
FROM {{ ref('stg_movies__raw_movies') }} AS m,
LATERAL FLATTEN(INPUT => PARSE_JSON(m.production_companies)) AS c