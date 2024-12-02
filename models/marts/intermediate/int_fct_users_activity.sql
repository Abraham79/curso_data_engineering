with 

cte_orders as (
    
    select *,
        a.order_cost_usd-b.discount_usd as order_total_income_usd


    from {{ ref('stg_sql_server_dbo__orders') }} a
    left join {{ ref('stg_sql_server_dbo__promos') }} b
    on a.promo_id = b.promo_id
    
),

cte_order_items as (
    
    select * from {{ ref('stg_sql_server_dbo__order_items') }}
    
),

cte_users as (

    select * from {{ ref('stg_sql_server_dbo__users') }}

),



renamed as (

    select distinct

        u.user_id,
        u.created_at_utc,
        u.updated_at_utc,
        u.address_id,
        u.last_name,
        u.first_name,
        u.phone_number,
        u.email,
        count(o.order_id)over(PARTITION BY u.user_id) as user_orders_count,
        sum(o.order_total_income_usd)over(PARTITION BY u.user_id) as user_total_income_usd,
        round(avg(o.order_total_income_usd)over(PARTITION BY u.user_id),2) as user_avg_income_usd,
        -- user_total_income_usd/(select sum(order_total_income_usd) from {{  ref('fct_orders_detail') }}) as percent_from_total_sales,
        sum(o.discount_usd)over(PARTITION BY u.user_id) as user_total_discounts_usd,
        u.deleted as deleted,
        u.insert_date_utc

    from cte_orders o
    LEFT JOIN cte_users u
    on u.user_id = o.user_id
    LEFT JOIN cte_order_items oi 
    on o.order_id = oi.order_id

    

)

select * from renamed
order by user_id