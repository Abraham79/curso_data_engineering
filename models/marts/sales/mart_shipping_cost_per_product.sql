with cte_orders_detail as (

    SELECT

        order_id,
        user_id,
        product_id,
        this_product_quantity,
        order_date_utc,
        promo_id,
        order_total_before_shipping_usd,
        different_products_in_order
        
    FROM {{ ref('fct_orders_detail') }}
),

cte_products as (

    SELECT 

        product_id,
        product_price_usd
    
    FROM {{ ref('dim_products') }}

), 


cte_shipping as (

    SELECT 
        order_id,
        shipping_cost_usd,
        tracking_id

    FROM {{ ref('dim_shipping') }}

),

cte_promos as (

        SELECT 
        *

    FROM {{ ref('dim_promos') }}

),


renamed AS (
    
    SELECT 
        
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
        ROUND(discount_usd*shipping_ratio, 2) as distributed_product_discount_usd,
        ROUND(discount_usd*shipping_ratio*o.this_product_quantity, 2) as single_product_discount_usd,
        ROUND(total_per_product_usd-discount_usd*shipping_ratio, 2) as discounted_product_price_usd,
        ROUND(s.shipping_cost_usd*shipping_ratio*o.this_product_quantity, 2) as distributed_shipping_cost,
        ROUND(s.shipping_cost_usd*shipping_ratio,2) as single_product_distributed_shipping_cost

        
    FROM cte_orders_detail o 
    LEFT JOIN cte_products p 
    ON o.product_id = p.product_id
    LEFT JOIN cte_shipping s
    ON o.order_id = s.order_id
    LEFT JOIN cte_promos d 
    on o.promo_id = d.promo_id
    ORDER BY o.order_id
)

SELECT * FROM renamed
