with 

source as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id,
        {{ tidy_string('name') }} as product_name,
        cast(price as decimal(16,2)) as product_price_usd,
        cast(inventory as numeric(16)) as product_stock,
        _fivetran_deleted as deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
