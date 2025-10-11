SELECT distinct
  k.VALUE:"id"::number AS keyword_id,
  k.VALUE:"name"::string AS keyword_name
FROM {{ ref('stg_movies__raw_movies') }},
LATERAL FLATTEN(INPUT => PARSE_JSON(keywords)) AS k
