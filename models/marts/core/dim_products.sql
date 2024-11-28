with 

source as (

    select * from {{ source('alumno1', 'stg_sql_server_dbo__products') }}

),

renamed as (

    select
        product_id,
        product_name,
        product_price_usd,
        product_stock,
        deleted,
        insert_date_utc

    from source

)

select * from renamed
