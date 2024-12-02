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

cte_int_users_totals as (

    select * from {{ ref('int_users_totals') }}

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
        ut.user_orders_count,
        count(o.order_id)over(PARTITION BY u.user_id) as user_products_count,
        ut.user_order_total_income_usd as user_total_income_usd,
        round(user_total_income_usd/user_orders_count,2) as user_avg_order_income_usd,
        round(user_total_income_usd/user_products_count,2) as user_avg_product_income_usd,
        user_total_income_usd/(select order_total_income_usd from {{ ref('int_total_sales_discounts') }}) as user_score,
        ut.user_total_promos_count,
        ut.user_total_discount_usd,
        u.deleted as deleted,
        u.insert_date_utc

    from cte_orders_detail o
    LEFT JOIN cte_users u
    on u.user_id = o.user_id
    LEFT JOIN cte_promos p
    on o.promo_id = p.promo_id
    LEFT JOIN cte_int_users_totals ut 
    on o.user_id = ut.user_id
    

)

select * from renamed
order by user_id