{%- macro drop_pr_staging_schemas(schema_suffix=null, PR_number=null) %}

    {% set pr_cleanup_query %}
        with pr_staging_schemas as (
            select schema_name
            from INFORMATION_SCHEMA.SCHEMATA
            where 1!=1
            {% if PR_number %}
                or schema_name like 'pr_'||{{ PR_number }}||'__%'
            {% endif %}
            {% if schema_suffix %}
                or schema_name like '{{ "%" ~ schema_suffix }}'
            {% endif %}
        )

        select
            'drop schema if exists '||schema_name||' cascade;' as drop_command
        from pr_staging_schemas
    {% endset %}

    {% do log(pr_cleanup_query, info=TRUE) %}

    {% set drop_commands = run_query(pr_cleanup_query).columns[0].values() %}

    {% if drop_commands %}
        {% for drop_command in drop_commands %}
            {% do log(drop_command, True) %} {% do run_query(drop_command) %}
        {% endfor %}
    {% else %} {% do log("No schemas to drop.", True) %}
    {% endif %}

{%- endmacro -%}
