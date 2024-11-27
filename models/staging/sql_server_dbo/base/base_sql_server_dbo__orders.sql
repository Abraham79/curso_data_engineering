with

    source as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed as (
        
        select
            order_id,
            nullif(TRIM(shipping_service), '') as shipping_service,
            {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} as shipping_service_id,
            cast(shipping_cost as decimal(16,2)) as shipping_cost_usd,
            address_id,
            {{ to_utc("created_at") }} as order_date_utc,
            nullif(TRIM({{ tidy_string('promo_id') }}), '') as promo_name,
            {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id,
            {{ to_utc("estimated_delivery_at") }} as estimated_delivery_date_utc,
            cast(order_cost as decimal(16,2)) as order_cost_usd,
            user_id,
            cast(order_total as decimal(16,2)) as order_total_usd,
            {{ to_utc("delivered_at") }} as delivery_date_utc,
            tracking_id,
            status,
            _fivetran_deleted as deleted,
            {{ to_utc("_fivetran_synced") }} as insert_date_utc
        from source 

    )

select *
from renamed
