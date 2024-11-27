SELECT *
FROM {{ ref('stg_sql_server_dbo__shipping') }}
WHERE estimated_delivery_date_utc < order_date_utc 
    OR delivery_date_utc < order_date_utc
/* comprueba si hay algún caso en el que la fecha de entrega o la fecha de 
entrega estimada sea anterior a la fecha en que se realizó el pedido, lo que 
no tendría sentido lógico e indicaría algún tipo de problema con los datos */