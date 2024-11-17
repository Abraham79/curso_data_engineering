{% macro query_as_array(query) %}

{# This macro returns an array of the form {(tuple_of_results)} #}

    {%- call statement('query_as_array', fetch_result=True,auto_begin=false) -%}

        {{ query }}

    {%- endcall -%}

    {% set sql_results={} %}

    {%- if execute -%}
        {% set sql_results_table = load_result('query_as_array').table.columns %}
        {% for column_name,column in sql_results_table.items() %}
            {% do sql_results.update({column_name: column.values()}) %}
            
        {% endfor %}
        
    {%- endif -%}
    
    {{ return(sql_results.values())}}

{% endmacro %}