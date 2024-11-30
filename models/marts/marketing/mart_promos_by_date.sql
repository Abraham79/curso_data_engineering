with 

cte_orders_detail as (

    select * from {{ ref('fct_orders_detail') }}


), 

cte_promos as (

    select * from {{ ref('dim_promos') }}

),

cte_time as (

    select * from {{ ref('dim_time') }}

),


renamed as (

    select distinct
        o.order_id,
        -- count(distinct o.order_id)over(partition by t.year_number) as num_orders_per_year,
        -- count(distinct o.order_id)over(partition by t.month_name) as num_orders_per_month,
        o.order_date_utc,
        -- o.product_id,
        o.order_total_before_shipping_usd,
        p.discount_usd,
        o.order_total_income_usd,
        t.day_of_week_name,
        t.month_name,
        t.quarter_of_year,
        t.year_number
        
    from cte_orders_detail o
    left join cte_promos p
    on o.promo_id = p.promo_id
    left join cte_time t
    on CAST(o.order_date_utc as DATE) = t.date_day
        



)

select * from renamed