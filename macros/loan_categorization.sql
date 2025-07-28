{% macro categorize_operation(operation) %}
    case
        when operation = "0"
        then "new_loan"
        when operation = "1"
        then "closed_loan"
        when operation = "2"
        then "adjusted_loan"
        when operation = "3"
        then "refinanced_loan"
        else "unknown_operation"
    end
{% endmacro %}
