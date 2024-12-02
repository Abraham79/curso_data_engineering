{% snapshot sql_server_dbo__users_snp%}
{{
    config(
        target_schema='snapshots',
        unique_key='user_id',
        strategy='check',
        check_cols=['updated_at_utc', 'address_id', 'last_name', 'first_name', 'phone_number', 'email' ]
    )
}}

SELECT

    user_id,
    updated_at_utc,
    address_id,
    last_name,
    first_name,
    phone_number,
    email, 

FROM {{ ref('stg_sql_server_dbo__users') }}

{% endsnapshot %}