select *

from {{ ref('stg_sql_server_dbo__users') }}

where email not like  '%@%.%' 

/* Checks mail from users for a valid format */

/* Please notice that '%_@__%.__%' or more complex check results in false positives for our particular use case */