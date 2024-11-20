with 

source as (

    select * from {{ source('sql_server_dbo', 'addresses') }}

),

renamed as (

    select
        address_id,
        address,
        zipcode,
        country,
        state,
        --_fivetran_deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
