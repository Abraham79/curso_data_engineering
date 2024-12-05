{{ config(
    materialized='incremental',
    unique_key = 'unique_hash'
    ) 
    }}
    

with 

source as (

    select * from {{ source('sql_server_dbo', 'order_items') }}

),

renamed as (

    select

        {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as unique_hash,
        order_id,
        product_id,
        cast(quantity as numeric(16)) as quantity,
        _fivetran_deleted as deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc,
        _fivetran_synced
        
    from source

)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}