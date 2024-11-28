with 

source as (

    select * from {{ ref('stg_sql_server_dbo__shipping') }}

),

renamed as (

    select
        order_id,
        shipping_cost_usd,
        order_date_utc,
        estimated_delivery_date_utc,
        delivery_date_utc,
        tracking_id,
        status,
        deleted,
        insert_date_utc

    from source

)

select * from renamed
