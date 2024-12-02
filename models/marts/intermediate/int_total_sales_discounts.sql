with 

cte_orders_promos as (
    
    select 
    
        count(a.order_id) as total_orders_count,
        sum(a.order_cost_usd) as order_total_usd,
        sum(a.order_cost_usd-b.discount_usd) as order_total_income_usd,
        sum(b.discount_usd) as total_discount_usd,
        count(nullif(a.promo_id, 'fa2cb83ccf3c62c316ce453bb4ea4ced')) as total_promos_count


    from {{ ref('stg_sql_server_dbo__orders') }} a
    left join {{ ref('stg_sql_server_dbo__promos') }} b
    on a.promo_id = b.promo_id
    
)

select * from cte_orders_promos