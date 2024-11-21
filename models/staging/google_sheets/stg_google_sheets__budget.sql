with 

source as (

    select * from {{ source('google_sheets', 'budget') }}

),

renamed as (

    select
        _row,
        product_id,
        quantity,
        {{ to_utc("month") }} as month_utc,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
