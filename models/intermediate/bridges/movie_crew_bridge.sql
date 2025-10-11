SELECT
  c.movie_id::string AS movie_id,
  cj.VALUE:"id"::string AS crew_id,
  cj.VALUE:"credit_id"::string as credit_id,
  cj.VALUE:"job"::string as job,
  cj.VALUE:"department"::string as department_name
FROM {{ ref('stg_movies__raw_credit') }} AS c,
LATERAL FLATTEN(INPUT => PARSE_JSON(c.crew_json)) AS cj