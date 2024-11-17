{% macro to_utc(column_name) %}
    
    dbt_date.convert_timezone({{ column_name }}, "UTC", "America/Los_Angeles") 

{% endmacro %}