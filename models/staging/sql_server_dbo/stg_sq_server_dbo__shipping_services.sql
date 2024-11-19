with 

source as (

    select * from {{ ref('base_sql_server_dbo__orders') }}

),

renamed as (

    select distinct
        shipping_service,
        shipping_service_hash

    from source

)

select * from renamed
