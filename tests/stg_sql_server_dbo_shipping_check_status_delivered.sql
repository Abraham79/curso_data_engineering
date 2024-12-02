select *

from ALUMNO1_DEV_SILVER_DB.ALUMNO1.STG_SQL_SERVER_DBO__SHIPPING

where status = 'delivered' and delivery_date_utc is null

/* delivered products must have delivery date */