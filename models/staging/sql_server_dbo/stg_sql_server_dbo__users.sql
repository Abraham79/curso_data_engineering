with 

source as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed as (

    select
        user_id,
        {{ to_utc("created_at") }} as created_at_utc,
        {{ to_utc("updated_at") }} as updated_at_utc,
        address_id,
        last_name,
        first_name,
        phone_number,
        email,
        _fivetran_deleted as deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
