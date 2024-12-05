{{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
    }}


with 

source as (

    select * from {{ source('google_sheets', 'budget') }}

),

renamed as (

    select
        _row,
        product_id,
        quantity,
        month({{ to_utc("month") }}) as month,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc,
        _fivetran_synced

    from source

)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}