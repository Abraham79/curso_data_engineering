{% macro to_utc(column_name) %}
    
    convert_timezone('America/Los_Angeles', 'UTC', cast({{ column_name }} as timestamp)) 

{% endmacro %}

/* convert data timezone to UTC */