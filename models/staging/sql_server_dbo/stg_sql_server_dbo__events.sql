with 

source as (

    select * from {{ source('sql_server_dbo', 'events') }}

),

renamed as (

    select
        event_id,
        page_url,
        event_type,
        user_id,
        nullif(trim(product_id), '') as product_id,
        session_id,
        {{ to_utc("created_at") }} as created_at_utc,
        nullif(trim(order_id), '') as order_id,
        _fivetran_deleted as deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc
       

    from source

)

select * from renamed
