{% macro remove_unneeded(string) %}
   trim ({{ string  }}, '[')
{% endmacro %}