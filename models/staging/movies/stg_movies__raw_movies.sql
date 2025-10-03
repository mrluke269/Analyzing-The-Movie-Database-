with 

source as (

    select * from {{ source('movies', 'raw_movies') }}

),

renamed as (

    select
        budget,
        genres,
        homepage,
        id,
        keywords,
        original_language,
        original_title,
        overview,
        popularity,
        production_companies,
        production_countries,
        cast(release_date as date) as release_date,
        revenue,
        runtime,
        spoken_languages,
        status,
        tagline,
        title,
        vote_average,
        vote_count

    from source

)

select * from renamed
