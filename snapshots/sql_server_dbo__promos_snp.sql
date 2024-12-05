{% snapshot sql_server_dbo__promos_snp%}
{{
    config(

        target_schema='snapshots',
        unique_key='promo_id',
        strategy='check',
        check_cols=['promo_name', 'discount_usd', 'status']

    )
}}

SELECT

   *

FROM {{ ref('stg_sql_server_dbo__promos') }}

{% endsnapshot %}