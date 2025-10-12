SELECT distinct
  l.VALUE:"iso_639_1"::string AS language_code,
  l.VALUE:"name"::string AS language
FROM {{ ref('stg_movies__raw_movies') }},
LATERAL FLATTEN(INPUT => PARSE_JSON(spoken_languages)) AS l