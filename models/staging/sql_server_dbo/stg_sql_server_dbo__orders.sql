with

    source as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed as (
        {% set valid_shipping_service = ("dhl", "fedex", "ups", "usps") %}
        {% set valid_promo_name = ("task-force", "leverage", "Mandatory", "Digitized", "instruction set", "Optional") %}
        

        select
            order_id,
            CASE
                WHEN shipping_service IN {{valid_shipping_service}} THEN shipping_service
                ELSE null
            END 
            shipping_service,
            shipping_cost,
            address_id,
            created_at,
            CASE
                WHEN promo_id in {{valid_promo_name}} then LOWER(promo_id)
                ELSE null 
            END as promo_name,
            md5(promo_name) as promo_id,
            estimated_delivery_at,
            order_cost,
            user_id,
            order_total,
            delivered_at,
            tracking_id,
            status,
            _fivetran_deleted,
            _fivetran_synced
        from source

    )

select *
from renamed
