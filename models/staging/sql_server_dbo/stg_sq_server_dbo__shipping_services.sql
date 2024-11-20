with 

source as (

    select * from {{ ref('base_sql_server_dbo__orders') }}

),

renamed as (

    select distinct
        
        shipping_service_id,
        shipping_service

    from source
    order by shipping_service

)

select * from renamed
