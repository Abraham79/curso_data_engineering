with 

source as (

    select * from {{ ref('base_sql_server_dbo__orders') }}

),

renamed as (

        select
            order_id,
            -- shipping_service_id,
            shipping_cost_usd,
            -- address_id,
            -- created_at,
            -- promo_name,
            -- promo_id,
            estimated_delivery_date_utc,
            -- order_cost_eur,
            -- user_id,
            -- order_total as order_total_eur,
            delivery_date_utc,
            tracking_id,
            status,
            --_fivetran_deleted,
            insert_date_utc
        from source 
    order by shipping_service

)

select * from renamed
