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
    SELECT *
        /*o.order_id,
        p.product_name,
        oi.quantity AS this_product_quantity,
        CASE
            WHEN row_number()over(partition by oi.order_id order by oi.order_id)=1
            THEN num_prod_order
        END as different_products_in_order,
        CASE
            WHEN row_number()over(partition by oi.order_id order by oi.order_id)=1
            THEN s.shipping_cost_usd
        END as order_shipping_cost_usd,
        -- s.shipping_cost_usd,
        --round(s.shipping_cost_usd/sum(oi.quantity)OVER(PARTITION BY o.order_id)*this_product_quantity, 2) as divided_shipping_cost,  --- sólo tiene en cuenta el número de productos
        
        product_price_usd*oi.quantity as total_per_product,
        SUM(total_per_product)OVER(PARTITION BY o.order_id) as total_order,
        CASE
            WHEN row_number()over(partition by oi.order_id order by oi.order_id)=1
            THEN total_order
        END as single_total_order,
        product_price_usd/total_order as percent,
        ROUND(shipping_cost_usd*percent*oi.quantity, 2) as distributed_shipping_cost,
        ROUND(shipping_cost_usd*percent,2) as single_product_distributed_shipping_cost
        
        */
        
 
    FROM cte_orders o 
    LEFT JOIN cte_order_items oi
    ON o.order_id = oi.order_id
    LEFT JOIN cte_products p 
    ON oi.product_id = p.product_id
    LEFT JOIN cte_shipping s
    ON o.order_id = s.order_id
    ORDER BY o.order_id
)

SELECT * FROM renamed;