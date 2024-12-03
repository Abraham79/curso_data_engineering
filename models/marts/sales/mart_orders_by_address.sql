with cte_orders_detail as (

    select

        *
        
    from {{ ref('fct_orders_detail') }}

),

cte_addresses as (

    select

    *
        
    from {{ ref('dim_addresses') }}

)

select * from cte_orders_detail o
left join cte_addresses a
on o.address_id = a.address_id