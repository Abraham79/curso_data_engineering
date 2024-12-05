{{ config(
    materialized='incremental',
    unique_key = 'promo_name'
    ) 
    }}


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
        insert_date_utc,
        _fivetran_synced

    from source

)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}