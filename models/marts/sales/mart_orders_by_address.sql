with cte_orders_detail as (

    select

        *
        
    from {{ ref('fct_orders_detail') }}

),

cte_addresses as (

    select

        address_id as sk,
        address,
        zipcode,
        country,
        state
        
    from {{ ref('dim_addresses') }}

)

select 

        o.*, 
        address,
        zipcode,
        country,
        state 

from cte_orders_detail o
left join cte_addresses a
on o.address_id = a.sk