with 

cte_users as (

    select * from {{ ref('dim_users') }}

),

cte_orders_detail as (
    
    select * from {{  ref('fct_orders_detail') }}),

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
        {{ single_row('count(o.order_id)over(PARTITION BY o.user_id)', 'user_num_order', 'o.user_id' ) }}
        {{ single_row('sum(o.order_total_before_shipping_usd)over(PARTITION BY o.user_id)', 'total_spent_usd', 'o.user_id' ) }}
        
        u.deleted as deleted,
        u.insert_date_utc

    from cte_users u
    LEFT JOIN cte_orders_detail o
    on u.user_id = o.user_id
    

)

select * from renamed
order by user_id