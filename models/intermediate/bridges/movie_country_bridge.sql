SELECT
  m.id::string AS movie_id,
  ct.VALUE:"iso_3166_1"::string AS country_code
FROM {{ ref('stg_movies__raw_movies') }} AS m,
LATERAL FLATTEN(INPUT => PARSE_JSON(m.production_countries)) AS ct