{{ config(
    materialized='incremental',
    unique_key = 'event_id'
    ) 
    }}

with 

source as (

    select 

        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at_utc,
        order_id,
        deleted,
        _fivetran_synced
    
    from {{ ref('stg_sql_server_dbo__events') }}

),

renamed as (

    select
    
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at_utc,
        order_id,
        deleted,
        _fivetran_synced

    from source

)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}