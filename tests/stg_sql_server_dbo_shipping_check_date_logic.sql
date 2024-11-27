SELECT *
FROM {{ ref('stg_sql_server_dbo__shipping') }}
WHERE estimated_delivery_date_utc < order_date_utc 
    OR delivery_date_utc < order_date_utc
/* Makes sure every order date is proir to its delivery or estimated 
delivery date, otherwise our source data may be wrong */