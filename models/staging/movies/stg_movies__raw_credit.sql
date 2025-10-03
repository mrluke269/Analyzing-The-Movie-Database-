with source as (
    select * from {{ source('movies', 'raw_credit') }}
),

renamed as (
    select
        c1::string as movie_id,
        c2::string as title,
        c3::variant as cast_json,
        c4::variant as crew_json
    from source
    where c1 != 'C1' and c1 != 'movie_id'
)

select * from renamed
