{% macro url_without_query_strings(url) %}
    regexp_replace({{ url }}, '\\?.*$', '')
{% endmacro %}
