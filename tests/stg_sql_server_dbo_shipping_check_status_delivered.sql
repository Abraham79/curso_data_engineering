select *

from {{ ref('stg_sql_server_dbo__shipping') }}

where status = 'delivered' and delivery_date_utc is null

/* delivered products must have delivery date */