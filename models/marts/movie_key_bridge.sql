SELECT
  m.id::string AS movie_id,
  k.VALUE:"id"::string AS key_id
FROM {{ ref('stg_movies__raw_movies') }} AS m,
LATERAL FLATTEN(INPUT => PARSE_JSON(m.keywords)) AS k