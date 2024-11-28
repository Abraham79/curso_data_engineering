with 

source as (

    select * from {{ source('alumno1', 'stg_sql_server_dbo__addresses') }}

),

renamed as (

    select
        address_id,
        address,
        zipcode,
        country,
        state,
        deleted,
        insert_date_utc

    from source

)

select * from renamed
