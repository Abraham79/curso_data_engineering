with 

cte_orders_detail as (
    
    select * from {{  ref('fct_orders_detail') }}
    
),

cte_users as (

    select * from {{ ref('dim_users') }}

),

cte_promos as (

    select * from {{ ref('dim_promos') }}

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
        user_total_income_usd/(select sum(order_total_income_usd) from {{  ref('fct_orders_detail') }}) as percent_from_total_sales,
        sum(p.discount_usd)over(PARTITION BY u.user_id) as user_total_discounts_usd,
        u.deleted as deleted,
        u.insert_date_utc

    from cte_orders_detail o
    LEFT JOIN cte_users u
    on u.user_id = o.user_id
    LEFT JOIN cte_promos p
    on o.promo_id = p.promo_id
    

)

select * from renamed
order by user_id