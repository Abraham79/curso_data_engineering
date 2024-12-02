select *

from {{ ref('stg_sql_server_dbo__shipping') }}

where estimated_delivery_date_utc < order_date_utc 
or delivery_date_utc < order_date_utc

/* Ensures every order date is proir to its delivery or estimated 
delivery date, otherwise our source data may be wrong */