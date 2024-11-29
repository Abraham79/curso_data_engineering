with 

cte_users as (

    select * from {{ ref('dim_users') }}

),

cte_order_math as (
    
    select * from {{  ref('mart_order_math') }}),

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
        count(om.order_id)over(PARTITION BY om.user_id) as num_orders,
        sum(om.order_total_before_shipping_usd)over(PARTITION BY om.user_id) as total_spent_usd,
        
        u.deleted as deleted,
        u.insert_date_utc

    from cte_users u
    LEFT JOIN cte_order_math om
    on u.user_id = om.user_id

)

select * from renamed
