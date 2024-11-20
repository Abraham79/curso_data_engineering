with

    source as (select * from {{  ref('base_sql_server_dbo__orders') }}),

    renamed as (
     
 
        select
            order_id,
            --shipping_service_id,
            --shipping_cost_usd,
            --address_id,
            order_date_utc,
            -- promo_name,
            promo_id,
            --estimated_delivery_date_utc,
            order_cost_usd,
            user_id,
            -- order_total as order_total_eur,
            --delivery_date_utc,
            tracking_id,
            -- status,
            --_fivetran_deleted,
            insert_date_utc
        from source 

    )

select *
from renamed
