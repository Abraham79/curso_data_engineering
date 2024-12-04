with

    source as (select * from {{  ref('base_sql_server_dbo__orders') }}),

    renamed as (
     
 
        select
            order_id,
            address_id,
            order_date_utc,
            promo_id,
            order_cost_usd, 
            user_id,
            tracking_id,
            deleted,
            insert_date_utc
        from source 

    )

select *
from renamed
