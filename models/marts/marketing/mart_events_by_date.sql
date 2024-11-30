with 

cte_events as (

    select * from {{ ref('fct_events') }}


), 


cte_time as (

    select * from {{ ref('dim_time') }}

),


renamed as (

    select *
        
    from cte_events e
    left join cte_time t
    on CAST(e.created_at_utc as DATE) = t.date_day
        



)

select * from renamed