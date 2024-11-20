with 

source as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id,
        price as product_price_usd,
        name as promo_name,
        inventory,
        --_fivetran_deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
