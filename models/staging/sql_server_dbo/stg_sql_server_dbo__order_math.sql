with 

cte_promos as (

    select * from {{ ref('base_sql_server_dbo__promos') }}

),

cte_orders as (

    select * from {{ ref('base_sql_server_dbo__orders') }}

), 

renamed as (


    select

        o.order_id,
        o.user_id,
        o.promo_id,
        ifnull(o.promo_name, 'no_promo') as promo_name,
        o.order_cost_usd,
        ifnull(p.discount_usd, 0) as discount_usd,
        o.shipping_cost_usd, 
        (o.order_cost_usd+o.shipping_cost_usd-p.discount_usd) as order_total_usd

    from cte_orders as o
    left join cte_promos as p
    on o.promo_id = p.promo_id 


)

select * from renamed
