with 

cte_orders as (

    select * from {{ ref('fct_orders_detail') }}

), 

cte_promos as (

    select * from {{ ref('dim_promos') }}

),

cte_shipping as (

    select * from {{ ref('dim_shipping') }}

),


renamed as (


    select

        o.order_id,
        o.user_id,
        o.promo_id,
        p.promo_name,
        p.discount_usd,
        /*{{ single_row('s.shipping_cost_usd','shipping_cost_usd', 'o.order_id' )}} */
        o.order_total_before_shipping_usd,
        o.order_total_income_usd,
        o.product_price_usd*o.this_product_quantity as total_per_product_usd

    from cte_orders as o
    left join cte_promos as p
    on o.promo_id = p.promo_id 
    left join cte_shipping s
    on o.order_id = s.order_id


)

select * from renamed
