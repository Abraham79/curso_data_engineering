with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        --LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_')) as promo_name,
        {{ reformat_string('promo_id') }} as promo_name,
        md5(promo_name) as promo_id,
        discount as discount_eur,
        status,
        --_fivetran_deleted,
        {{ dbt_date.convert_timezone("_fivetran_synced", "UTC", "America/Los_Angeles") }} as insert_date_utc

    from source

)

select * from renamed
