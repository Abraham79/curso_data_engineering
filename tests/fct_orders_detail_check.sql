with cte_fct_order_details as (

    select 

        md5('sk') as sk,
        count(order_id) as check_total_orders

    from (  select distinct 
            header_line_hash, 
            order_id 
            from {{ ref('fct_orders_detail') }}
    )

    group by sk

),

cte_base_orders as (

    select 

        md5('sk') as sk,
        count(order_id) as check_total_orders
        
    from {{ ref('base_sql_server_dbo__orders') }}
    group by sk

),

renamed as (

    select 

        gold.check_total_orders,
        base.check_total_orders
    
    from cte_fct_order_details gold
    left join cte_base_orders base
    on gold.sk = base.sk
    where gold.check_total_orders <> base.check_total_orders

)

select * from renamed 

/* Checks fct_order_details Header/line hash is working as expected */