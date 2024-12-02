with 

source as (

    select * from {{ ref('stg_sql_server_dbo__promos') }}
),

renamed as (

    select
    
        promo_name,
        promo_id,
        discount_usd,
        status,
        deleted,
        insert_date_utc

    from source

)

select * from renamed
