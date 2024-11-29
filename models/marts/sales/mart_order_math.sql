with 

cte_orders as (

    select * from {{ ref('fct_orders') }}

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
        ifnull(p.promo_name, 'no_promo') as promo_name,
        o.order_cost_usd,
        ifnull(p.discount_usd, 0) as discount_usd,
        s.shipping_cost_usd, 
        (o.order_cost_usd-p.discount_usd) as order_total_before_shipping_usd,
        (o.order_cost_usd+s.shipping_cost_usd-p.discount_usd) as order_total_plus_shipping_usd

    from cte_orders as o
    left join cte_promos as p
    on o.promo_id = p.promo_id 
    left join cte_shipping s
    on o.order_id = s.order_id


)

select * from renamed
