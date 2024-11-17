with

    source as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed as (
     
        {% set valid_promos = dbt_utils.get_column_values(table=ref("stg_sql_server_dbo__promos"), column='promo_id') %}
        {% set valid_shipping_service = ("dhl", "fedex", "ups", "usps") %}

        select
            order_id,
            CASE
                WHEN shipping_service IN {{valid_shipping_service}} THEN shipping_service
                ELSE null
            END 
            shipping_service,
            shipping_cost as shipping_cost_eur,
            address_id,
            created_at,
            CASE
                WHEN promo_id in ({{ "'" ~ valid_promos | join("', '") ~ "'"}}) then {{ reformat_string('promo_id') }}--LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_'))
                ELSE 'none' 
            END as promo_name,
            md5(promo_name) as promo_id,
            estimated_delivery_at,
            order_cost as order_cost_eur,
            user_id,
            order_total as order_total_eur,
            delivered_at,
            tracking_id,
            status,
            --_fivetran_deleted,
            _fivetran_synced as insert_date
        from source 

    )

select *
from renamed
