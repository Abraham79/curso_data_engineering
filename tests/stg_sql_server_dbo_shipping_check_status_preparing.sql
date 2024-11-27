SELECT *
FROM ALUMNO1_DEV_SILVER_DB.ALUMNO1.STG_SQL_SERVER_DBO__SHIPPING
WHERE status = 'preparing' and delivery_date_utc is not null

/* Si un producto se está preparando, no debe tener fecha de entrega */