with

    source as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed as (
        
        select
            order_id,
            nullif(TRIM(shipping_service), '') as shipping_service,
            {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} as shipping_service_id,
            shipping_cost as shipping_cost_usd,
            address_id,
            {{ to_utc("created_at") }} as order_date_utc,
            nullif(TRIM({{ tidy_string('promo_id') }}), '') as promo_name,
            {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id,
            {{ to_utc("estimated_delivery_at") }} as estimated_delivery_date_utc,
            order_cost as order_cost_usd,
            user_id,
            order_total as order_total_usd,
            {{ to_utc("delivered_at") }} as delivery_date_utc,
            tracking_id,
            status,
            _fivetran_deleted,
            {{ to_utc("_fivetran_synced") }} as insert_date_utc
        from source 

    )

select *
from renamed
