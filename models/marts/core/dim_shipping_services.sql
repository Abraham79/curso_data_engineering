with 

source as (

    select * from {{ source('alumno1', 'stg_sql_server_dbo__shipping_services') }}

),

renamed as (

    select
        shipping_service_id,
        shipping_service

    from source

)

select * from renamed
