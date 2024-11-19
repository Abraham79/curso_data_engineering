with 

source as (

    select * from {{ source('prueba_snapshot', 'users') }}

),

renamed as (

    select
        nombre,
        dni,
        email,
        fecha_alta_sistema

    from source

)

select * from renamed
