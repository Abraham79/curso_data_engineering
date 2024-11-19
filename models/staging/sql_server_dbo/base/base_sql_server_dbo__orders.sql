with

    source as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed as (
     
        {% set valid_promos = dbt_utils.get_column_values(table=ref("stg_sql_server_dbo__promos"), column='promo_id') %}
        
        select
            order_id,
            nullif(TRIM(shipping_service), '') as shipping_service,
            {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} as shipping_service_hash,
            shipping_cost as shipping_cost_eur,
            address_id,
            created_at,
            CASE
                WHEN promo_id in ('{{ valid_promos | join("', '") }}') then {{ tidy_string('promo_id') }}
                ELSE 'none' 
            END as promo_name,
            {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id,
            estimated_delivery_at,
            order_cost as order_cost_eur,
            user_id,
            order_total as order_total_eur,
            delivered_at,
            tracking_id,
            status,
            _fivetran_deleted,
            {{ to_utc("_fivetran_synced") }} as insert_date_utc
        from source 

    )

select *
from renamed
