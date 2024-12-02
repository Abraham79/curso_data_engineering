with cte_order_items as (

    SELECT

        order_id,
        product_id,
        quantity,
        COUNT(product_id)OVER(PARTITION BY order_id) AS num_prod_order
        
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
),

cte_products as (

    SELECT *
    
    FROM {{ ref('stg_sql_server_dbo__products') }}
), 

cte_orders as (

    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders') }}

),

cte_shipping as (

    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__shipping') }}

),

cte_promos as (

    SELECT * FROM {{ ref('stg_sql_server_dbo__promos') }}

),

renamed AS (
    
    SELECT 
        
        
        {{ dbt_utils.generate_surrogate_key(['o.order_id', 'o.order_date_utc', 'o.order_cost_usd']) }} as header_line_hash,
        o.order_id,
        o.user_id,
        o.order_date_utc,
        oi.product_id,
        o.promo_id,
        -- o.tracking_id,
        -- p.product_price_usd,
        oi.quantity AS this_product_quantity,
        oi.num_prod_order as different_products_in_order,
        -- s.shipping_cost_usd as order_shipping_cost_usd,
        -- SUM(total_per_product)OVER(PARTITION BY o.order_id) as total_order,
        /*{{ single_row('SUM(total_per_product_usd)OVER(PARTITION BY o.order_id)', 'order_total_before_shipping_usd', 'oi.order_id' ) }}*/
        o.order_cost_usd as order_total_before_shipping_usd,
        -- d.discount_usd,
        order_total_before_shipping_usd-d.discount_usd as order_total_income_usd,
        -- order_total_income_usd+order_shipping_cost_usd as user_payment
        -- product_price_usd/total_order as shipping_ratio,
        -- ROUND(shipping_cost_usd*shipping_ratio*oi.quantity, 2) as distributed_shipping_cost,
        -- ROUND(shipping_cost_usd*shipping_ratio,2) as single_product_distributed_shipping_cost

        
    FROM cte_orders o 
    LEFT JOIN cte_order_items oi
    ON o.order_id = oi.order_id
    LEFT JOIN cte_promos d
    on o.promo_id = d.promo_id
    LEFT JOIN cte_products p 
    ON oi.product_id = p.product_id
    LEFT JOIN cte_shipping s
    ON o.order_id = s.order_id
    ORDER BY o.order_id
)

SELECT * FROM renamed
