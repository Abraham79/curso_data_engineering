with

    source as (select * from {{  ref('base_sql_server_dbo__orders') }}),

    renamed as (
     
 
        select
            order_id,
            shipping_service_hash,
            shipping_cost_eur,
            address_id,
            created_at,
            promo_name,
            promo_id,
            estimated_delivery_at,
            order_cost_eur,
            user_id,
            -- order_total as order_total_eur,
            delivered_at,
            tracking_id,
            status,
            --_fivetran_deleted,
            insert_date_utc
        from source 

    )

select *
from renamed
