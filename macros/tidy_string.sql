{% macro tidy_string(column_name) %}
    
    LOWER(REPLACE(REPLACE({{ column_name }}, ' ', '_'), '-', '_'))

{% endmacro %}