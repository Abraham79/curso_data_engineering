{% macro single_row(in_column_name, out_column_name, partition_column_name) %}
    
    CASE
        WHEN row_number()over(partition by {{ partition_column_name }} order by {{ partition_column_name }})=1
        THEN {{ in_column_name }}
    END as {{ out_column_name }},

{% endmacro %}