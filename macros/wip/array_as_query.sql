{% macro array_as_query(query) %}

    ('{{ query | join("', '") }}')

{% endmacro %}