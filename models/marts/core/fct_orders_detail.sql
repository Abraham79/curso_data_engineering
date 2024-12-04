{{ config(
    materialized='incremental',
    unique_key = 'unique_hash'
    ) 
    }}

with 

cte_order_items as (

    select

        order_id,
        product_id,
        quantity,
        count(product_id)over(partition by order_id) as num_prod_order,
        _fivetran_synced
        
    from {{ ref('stg_sql_server_dbo__order_items') }}
),


cte_orders as (

    select * 

    from {{ ref('stg_sql_server_dbo__orders') }}

),

cte_shipping as (

    select * 

    from {{ ref('stg_sql_server_dbo__shipping') }}

),

cte_promos as (

    select * 
    
    from {{ ref('stg_sql_server_dbo__promos') }}

),

renamed AS (
    
    select 
        
        {{ dbt_utils.generate_surrogate_key(['o.order_id', 'o.order_date_utc']) }} as header_line_hash,
        {{ dbt_utils.generate_surrogate_key(['o.order_id', 'product_id']) }} as unique_hash,      
        o.order_id,
        o.user_id,
        o.address_id,
        o.order_date_utc,
        oi.product_id,
        o.promo_id,
        oi.quantity as this_product_quantity,
        oi.num_prod_order as different_products_in_order,
        o.order_cost_usd as order_total_before_shipping_usd,
        d.discount_usd as order_discount_usd,
        order_total_before_shipping_usd-d.discount_usd as order_total_income_usd,
        s.shipping_cost_usd as order_shipping_cost_usd,
        order_total_income_usd+s.shipping_cost_usd as order_total_plus_shipping,     
        o.deleted,
        o._fivetran_synced,
        oi._fivetran_synced as _fivetran_synced_oi,
        d._fivetran_synced as _fivetran_synced_d

        
    from cte_orders o 
    left join cte_order_items oi
    on o.order_id = oi.order_id
    left join cte_promos d
    on o.promo_id = d.promo_id
    left join cte_shipping s
    on o.order_id = s.order_id
    order by o.order_id
)

SELECT * FROM renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})
  and _fivetran_synced > (select max(_fivetran_synced_oi) from {{ this }})
  and _fivetran_synced > (select max(_fivetran_synced_d) from {{ this }})

{% endif %}