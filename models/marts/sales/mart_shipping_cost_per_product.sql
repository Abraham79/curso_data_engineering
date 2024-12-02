with cte_orders_detail as (

    select

        order_id,
        user_id,
        product_id,
        this_product_quantity,
        order_date_utc,
        promo_id,
        order_total_before_shipping_usd,
        different_products_in_order
        
    from {{ ref('fct_orders_detail') }}
),

cte_products as (

    select 

        product_id,
        product_price_usd
    
    from {{ ref('dim_products') }}

), 


cte_shipping as (

    select

        order_id,
        shipping_cost_usd,
        tracking_id

    from {{ ref('dim_shipping') }}

),

cte_promos as (

    select *

    from {{ ref('dim_promos') }}

),


renamed as (
    
    select 
        
        o.order_id,
        o.user_id,
        o.order_date_utc,
        p.product_id,
        o.promo_id,
        s.tracking_id,
        p.product_price_usd,
        o.this_product_quantity,
        p.product_price_usd*o.this_product_quantity as total_per_product_usd,
        d.discount_usd as total_order_discount,

        p.product_price_usd/o.order_total_before_shipping_usd as shipping_ratio,
        round(discount_usd*shipping_ratio, 2) as distributed_product_discount_usd,
        round(discount_usd*shipping_ratio*o.this_product_quantity, 2) as single_product_discount_usd,
        round(total_per_product_usd-discount_usd*shipping_ratio, 2) as discounted_product_price_usd,
        round(s.shipping_cost_usd*shipping_ratio*o.this_product_quantity, 2) as distributed_shipping_cost,
        round(s.shipping_cost_usd*shipping_ratio,2) as single_product_distributed_shipping_cost

        
    from cte_orders_detail o 
    left join cte_products p 
    on o.product_id = p.product_id
    left join cte_shipping s
    on o.order_id = s.order_id
    left join cte_promos d 
    on o.promo_id = d.promo_id
    order by o.order_id
)

select * from renamed
