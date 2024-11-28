with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        
        {{ tidy_string('promo_id') }} as promo_name,
        {{ dbt_utils.generate_surrogate_key(['promo_name']) }} as promo_id,
        cast(discount as decimal(16,2)) as discount_usd,
        status,
        _fivetran_deleted as deleted,
        {{ to_utc("_fivetran_synced") }} as insert_date_utc

    from source
    union all
    select
        'no_promo',
        {{ dbt_utils.generate_surrogate_key(["'no_promo'"]) }} as promo_id,
        0,
        NULL,
        NULL,
        NULL

)

select * from renamed