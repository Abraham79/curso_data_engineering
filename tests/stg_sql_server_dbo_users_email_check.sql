SELECT *
FROM {{ ref('stg_sql_server_dbo__users') }}
WHERE email not like '%@%.%'

/* Comprueba que el email de USERS tiene un formato válido */