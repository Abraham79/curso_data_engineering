with cte_orders_detail as (

    select

        *

    from {{ ref('fct_orders_detail') }}

),

cte_promos as (

    select * 
    
    from {{ ref('dim_promos') }}

),

cte_products as (

    select * 
    
    from {{ ref('dim_products') }}

)

select 
    
    o.* ,
    
        p.product_price_usd/o.order_total_before_shipping_usd as shipping_ratio,
        d.discount_usd*shipping_ratio as single_product_distributed_discount_usd,
        d.discount_usd*shipping_ratio*o.this_product_quantity as distributed_product_discount_usd,
    p.product_name,
    nullif(d.promo_name, 'no_promo') as promo_name
    
from cte_orders_detail o
left join cte_promos d 
on o.promo_id = d.promo_id
left join cte_products p
on o.product_id = p.product_id