with cte_order_items as (

    SELECT

        order_id,
        product_id,
        quantity,
        COUNT(product_id)OVER(PARTITION BY order_id) AS num_prod_order
        
    FROM {{ ref('fct_order_items') }}
),

cte_products as (

    SELECT *
    
    FROM {{ ref('dim_products') }}
), 

cte_orders as (

    SELECT * 
    FROM {{ ref('fct_orders') }}

),

cte_shipping as (

    SELECT * 
    FROM {{ ref('dim_shipping') }}

),

renamed AS (
    
    SELECT 
        
        o.order_id,
        o.user_id,
        o.order_date_utc,
        p.product_id,
        o.promo_id,
        o.tracking_id,
        p.product_price_usd,
        oi.quantity AS this_product_quantity,
        {{ single_row('num_prod_order', 'different_products_in_order', 'oi.order_id' ) }}
        {{ single_row('s.shipping_cost_usd', 'order_shipping_cost_usd', 'oi.order_id' ) }}
        product_price_usd*oi.quantity as total_per_product_usd,
        -- SUM(total_per_product)OVER(PARTITION BY o.order_id) as total_order,
        {{ single_row('SUM(total_per_product_usd)OVER(PARTITION BY o.order_id)', 'total_order_before_shipping_usd', 'oi.order_id' ) }}
        total_order_before_shipping_usd+order_shipping_cost_usd as total_order_plus_shipping_usd
        -- product_price_usd/total_order as shipping_ratio,
        -- ROUND(shipping_cost_usd*shipping_ratio*oi.quantity, 2) as distributed_shipping_cost,
        -- ROUND(shipping_cost_usd*shipping_ratio,2) as single_product_distributed_shipping_cost

        
    FROM cte_orders o 
    LEFT JOIN cte_order_items oi
    ON o.order_id = oi.order_id
    LEFT JOIN cte_products p 
    ON oi.product_id = p.product_id
    LEFT JOIN cte_shipping s
    ON o.order_id = s.order_id
    ORDER BY o.order_id
)

SELECT * FROM renamed