with 

source as (

    select * from {{ ref('stg_sql_server_dbo__order_items') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity,
        deleted,
        insert_date_utc

    from source

)

select * from renamed
