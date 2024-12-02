with 

cte_mart_users_act as (

    select 

        md5('sk') as sk,
        sum(user_total_income_usd)+sum(user_total_discount_usd) as total_sales

    from {{ ref('mart_users_activity') }}
    group by sk

),

cte_base_orders as (

    select 

        md5('sk') as sk,
        sum(order_cost_usd) as check_total_sales
        
    from {{ ref('base_sql_server_dbo__orders') }}
    group by sk

),

renamed as (select

                mart.total_sales,
                base.check_total_sales

            from cte_mart_users_act mart
            left join cte_base_orders base
            on mart.sk = base.sk
            where mart.total_sales <> base.check_total_sales

)

select * from renamed
