SELECT
  c.movie_id::string AS movie_id,
  cj.VALUE:"id"::string AS crew_id
FROM {{ ref('stg_movies__raw_credit') }} AS c,
LATERAL FLATTEN(INPUT => PARSE_JSON(c.crew_json)) AS cj