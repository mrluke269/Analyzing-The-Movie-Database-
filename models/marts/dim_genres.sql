SELECT distinct
  g.VALUE:"id"::number AS genre_id,
  g.VALUE:"name"::string AS genre_name
FROM {{ ref('stg_movies__raw_movies') }},
LATERAL FLATTEN(INPUT => PARSE_JSON(genres)) AS g
