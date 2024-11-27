with 

source as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id,
        {{ tidy_string('name') }} as product_name,
        price as product_price_usd,
        inventory as product_stock,
        _fivetran_deleted as deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
