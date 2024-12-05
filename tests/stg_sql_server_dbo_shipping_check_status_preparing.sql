select *

from {{ ref('stg_sql_server_dbo__shipping') }}

where status = 'preparing' and delivery_date_utc is not null

/* Products with status such as 'preparing' can not have a delivery date */