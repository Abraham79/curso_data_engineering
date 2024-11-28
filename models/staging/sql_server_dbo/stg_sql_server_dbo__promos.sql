with 

source as (

    select * from {{ ref('base_sql_server_dbo__promos') }}

),

renamed as (

    select *
        
    from source

)

select * from renamed
