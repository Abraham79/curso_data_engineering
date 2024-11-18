with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        
        {{ tidy_string('promo_id') }} as promo_name,
        md5(promo_name) as promo_id,
        discount as discount_eur,
        status,
        --_fivetran_deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source

)

select * from renamed
