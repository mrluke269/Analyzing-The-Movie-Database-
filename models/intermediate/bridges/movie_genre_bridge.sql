SELECT
  m.id::string AS movie_id,
  g.VALUE:"id"::string AS genre_id
FROM {{ ref('stg_movies__raw_movies') }} AS m,
LATERAL FLATTEN(INPUT => PARSE_JSON(m.genres)) AS g