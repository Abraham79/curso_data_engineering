{% snapshot sql_server_dbo__addresses_snp%}
{{
    config(

        target_schema='snapshots',
        unique_key='address_id',
        strategy='check',
        check_cols=['address', 'zipcode', 'country', 'state']

    )
}}

SELECT

   *

FROM {{ ref('stg_sql_server_dbo__addresses') }}

{% endsnapshot %}