with 

cte_orders_detail as (
    
    select * from {{  ref('fct_orders_detail') }}
    
),

cte_users as (

    select * from {{ ref('dim_users') }}

),

renamed as (

    select

        u.user_id,
        u.created_at_utc,
        u.updated_at_utc,
        u.address_id,
        u.last_name,
        u.first_name,
        u.phone_number,
        u.email,
        {{ single_row('count(o.order_id)over(PARTITION BY o.user_id)', 'user_orders_count', 'o.user_id' ) }}
        {{ single_row('sum(o.order_total_before_shipping_usd)over(PARTITION BY o.user_id)', 'user_spent_total_usd', 'o.user_id' ) }}
        {{ single_row('round(avg(o.order_total_before_shipping_usd)over(PARTITION BY o.user_id),2)', 'user_avg_spent_usd', 'o.user_id' ) }}
        user_spent_total_usd/(select sum(order_total_before_shipping_usd) from {{  ref('fct_orders_detail') }}) as percent_from_total_sales,
        u.deleted as deleted,
        u.insert_date_utc

    from cte_orders_detail o
    LEFT JOIN cte_users u
    on o.user_id = u.user_id
    

)

select * from renamed
order by user_id