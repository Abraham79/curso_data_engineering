with 

source as (

    select * from {{ source('alumno1', 'stg_google_sheets__budget') }}

),

renamed as (

    select
        _row,
        product_id,
        quantity,
        month,
        insert_date_utc

    from source

)

select * from renamed
