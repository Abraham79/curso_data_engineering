with 

source as (

    select * from {{ source('google_sheets', 'budget') }}

),

renamed as (

    select
        _row,
        quantity,
        {{ to_utc("month") }} as month_utc,
        product_id,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
