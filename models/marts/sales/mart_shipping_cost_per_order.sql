with cte_orders_detail as (

    select

        order_id,
        user_id,
        order_date_utc,
        order_total_before_shipping_usd,
        promo_id,
        count(product_id)over(partition by order_id) as num_prod_order
        
    from {{ ref('fct_orders_detail') }}
),




cte_shipping as (

    select * 

    from {{ ref('dim_shipping') }}

),

renamed as (
    
    select distinct
        
        o.order_id,
        o.user_id,
        o.order_date_utc,
        o.promo_id,
        s.tracking_id,
        s.shipping_cost_usd as order_shipping_cost_usd,
        order_total_before_shipping_usd,
        order_total_before_shipping_usd+order_shipping_cost_usd as order_total_plus_shipping_usd,
        --product_price_usd/order_total_before_shipping_usd as shipping_ratio,
        --ROUND(shipping_cost_usd*shipping_ratio*o.this_product_quantity, 2) as distributed_shipping_cost,
        --ROUND(shipping_cost_usd*shipping_ratio,2) as single_product_distributed_shipping_cost

        
    from cte_orders_detail o 
    left join cte_shipping s
    on o.order_id = s.order_id
    order by o.order_id
)

select * from renamed
