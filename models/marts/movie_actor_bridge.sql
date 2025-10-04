SELECT
  c.movie_id::string AS movie_id,
  cj.VALUE:"id"::string AS actor_id
FROM {{ ref('stg_movies__raw_credit') }} AS c,
LATERAL FLATTEN(INPUT => PARSE_JSON(c.cast_json)) AS cj