with 

source as (

    select * from {{ source('sql_server_dbo', 'order_items') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity,
        -- _fivetran_deleted,
        {{ dbt_date.convert_timezone("_fivetran_synced", "UTC", "America/Los_Angeles") }} as insert_date_utc
    from source

)

select * from renamed
