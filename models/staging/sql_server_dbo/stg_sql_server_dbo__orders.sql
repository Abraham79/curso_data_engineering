{{ config(
    materialized='incremental',
    unique_key = 'order_id'
    ) 
    }}


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
            _fivetran_synced
        from source 

    )

select *
from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
