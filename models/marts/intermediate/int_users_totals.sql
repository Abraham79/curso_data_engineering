with 

cte_orders_promos as (
    
    select 

        a.user_id,
        count(a.order_id) as user_orders_count,
        sum(a.order_cost_usd) as user_order_total_usd,
        sum(a.order_cost_usd-b.discount_usd) as user_order_total_income_usd,
        sum(b.discount_usd) as user_total_discount_usd,
        count(nullif(a.promo_id, 'fa2cb83ccf3c62c316ce453bb4ea4ced')) as user_total_promos_count

    from {{ ref('stg_sql_server_dbo__orders') }} a
    left join {{ ref('stg_sql_server_dbo__promos') }} b
    on a.promo_id = b.promo_id
    group by user_id
    
)

select * from cte_orders_promos