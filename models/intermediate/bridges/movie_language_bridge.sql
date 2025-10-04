SELECT
  m.id::string AS movie_id,
  l.VALUE:"iso_639_1"::string AS language_code
FROM {{ ref('stg_movies__raw_movies') }} AS m,
LATERAL FLATTEN(INPUT => PARSE_JSON(m.spoken_languages)) AS l