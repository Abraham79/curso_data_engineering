{{ config(
    materialized='incremental',
    unique_key = 'user_id'
    ) 
    }}


with 

source as (

    select * from {{ ref('stg_sql_server_dbo__users') }}

),

renamed as (

    select
    
        user_id,
        created_at_utc,
        updated_at_utc,
        address_id,
        last_name,
        first_name,
        phone_number,
        email,
        deleted,
        insert_date_utc, 
        _fivetran_synced

    from source

)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}