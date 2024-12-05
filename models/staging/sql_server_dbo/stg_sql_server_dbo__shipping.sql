with 

source as (

    select * from {{ ref('base_sql_server_dbo__orders') }}

),

renamed as (

        select
            order_id,
            shipping_service_id,
            shipping_cost_usd,
            address_id,
            order_date_utc,
            estimated_delivery_date_utc,
            delivery_date_utc,
            tracking_id,
            status,
            deleted,
            insert_date_utc
        from source 
    order by shipping_service

)

select * from renamed
