select *

from ALUMNO1_DEV_SILVER_DB.ALUMNO1.STG_SQL_SERVER_DBO__SHIPPING

where status = 'preparing' and delivery_date_utc is not null

/* Products with status such as 'preparing' can not have a delivery date */