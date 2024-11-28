with 

cte_users as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

cte_order_math as (
    
    select * from {{  ref('stg_sql_server_dbo__order_math') }}),

renamed as (

    select

        u.user_id,
        {{ to_utc("u.created_at") }} as created_at_utc,
        {{ to_utc("u.updated_at") }} as updated_at_utc,
        u.address_id,
        u.last_name,
        u.first_name,
        u.phone_number,
        u.email,
        count(o.order_id)over(PARTITION BY o.user_id) as num_orders,
        sum(o.order_total_usd)over(PARTITION BY o.user_id) as total_spent_usd,
        
        u._fivetran_deleted as deleted,
        {{ to_utc("u._fivetran_synced") }} as insert_date_utc

    from cte_users u
    LEFT JOIN cte_order_math o
    on u.user_id = o.user_id

)

select * from renamed
