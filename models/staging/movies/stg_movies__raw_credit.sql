with 

source as (

    select * from {{ source('movies', 'raw_credit') }}

),

renamed as (

    select
        c1,
        c2,
        c3,
        c4

    from source

)

select * from renamed
