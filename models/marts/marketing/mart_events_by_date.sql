with 

cte_events as (

    select * from {{ ref('fct_events') }}


), 


cte_time as (

    select 
    
        day_of_week_name,
        month_name,
        quarter_of_year,
        year_number,
        date_day
    
    from {{ ref('dim_time') }}

),


renamed as (

    select 

        e.*,
        t.day_of_week_name,
        t.month_name,
        t.quarter_of_year,
        t.year_number
        
    from cte_events e
    left join cte_time t
    on CAST(e.created_at_utc as DATE) = t.date_day
        



)

select * from renamed