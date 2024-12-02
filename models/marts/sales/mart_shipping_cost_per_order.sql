with cte_orders_detail as (

    SELECT

        order_id,
        user_id,
        --product_id,
        --this_product_quantity,
        order_date_utc,
        order_total_before_shipping_usd,
        promo_id,
        COUNT(product_id)OVER(PARTITION BY order_id) AS num_prod_order
        
    FROM {{ ref('fct_orders_detail') }}
),




cte_shipping as (

    SELECT * 
    FROM {{ ref('dim_shipping') }}

),

renamed AS (
    
    SELECT DISTINCT
        
        o.order_id,
        o.user_id,
        o.order_date_utc,

        o.promo_id,
        s.tracking_id,


        s.shipping_cost_usd as order_shipping_cost_usd,
        --product_price_usd*o.this_product_quantity as total_per_product_usd,
        --SUM(total_per_product_usd)OVER(PARTITION BY o.order_id) as order_total,
        order_total_before_shipping_usd,
        order_total_before_shipping_usd+order_shipping_cost_usd as order_total_plus_shipping_usd,
        --product_price_usd/order_total_before_shipping_usd as shipping_ratio,
        --ROUND(shipping_cost_usd*shipping_ratio*o.this_product_quantity, 2) as distributed_shipping_cost,
        --ROUND(shipping_cost_usd*shipping_ratio,2) as single_product_distributed_shipping_cost

        
    FROM cte_orders_detail o 
    LEFT JOIN cte_shipping s
    ON o.order_id = s.order_id
    ORDER BY o.order_id
)

SELECT * FROM renamed
