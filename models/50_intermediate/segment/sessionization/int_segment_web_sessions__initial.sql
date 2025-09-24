{{
    config(
        materialized="incremental",
        unique_key="session_id",
        sort="session_start_tstamp",
        partition_by={
            "field": "session_start_tstamp",
            "data_type": "timestamp",
            "granularity": var("segment_bigquery_partition_granularity"),
        },
        dist="session_id",
        cluster_by="session_id",
    )
}}

{% set partition_by = "partition by source_name, session_id" %}

{% set window_clause = (
    "partition by source_name, session_id"
    ~ " order by event_number"
    ~ " rows between unbounded preceding and unbounded following"
) %}

{% set first_values = {
    "utm_source": "utm_source",
    "utm_content": "utm_content",
    "utm_medium": "utm_medium",
    "utm_campaign": "utm_campaign",
    "utm_term": "utm_term",
    "gclid": "gclid",
    "page_url": "first_page_url",
    "page_url_host": "first_page_url_host",
    "page_url_path": "first_page_url_path",
    "page_url_query": "first_page_url_query",
    "referrer": "referrer",
    "referrer_host": "referrer_host",
    "device": "device",
    "device_category": "device_category",
} %}

{% set last_values = {
    "page_url": "last_page_url",
    "page_url_host": "last_page_url_host",
    "page_url_path": "last_page_url_path",
    "page_url_query": "last_page_url_query",
} %}

{% for col in var("segment_pass_through_columns") %}
    {% do first_values.update({col: "first_" ~ col}) %}
    {% do last_values.update({col: "last_" ~ col}) %}
{% endfor %}

with
    pageviews_sessionized as (

        select *
        from
            {{ ref("int_segment_web_events__sessionized") }}

            {% if is_incremental() %}
                {{
                    generate_sessionization_incremental_filter(
                        this, "tstamp", "session_start_tstamp", ">"
                    )
                }}
            {% endif %}

    ),

    referrer_mapping as (
        select
            source as map_source,
            medium as map_medium,
            lower(replace(host, 'www.', '')) as host_key
        from {{ ref("referrer_mapping") }}

    ),

    agg as (

        select distinct
            source_name,
            session_id,
            anonymous_id,
            min(tstamp) over ({{ partition_by }}) as session_start_tstamp,
            max(tstamp) over ({{ partition_by }}) as session_end_tstamp,
            {% for metric in var("session_metrics") %}
                countif(event_name = '{{ metric.event_name }}') over (
                    {{ partition_by }}
                ) as {{ metric.metric_name }},
            {% endfor %}
            {% for (key, value) in first_values.items() %}
                first_value({{ key }}) over ({{ window_clause }}) as {{ value }},
            {% endfor %}

            {% for (key, value) in last_values.items() %}
                last_value({{ key }}) over ({{ window_clause }}) as {{ value }}
                {% if not loop.last %},{% endif %}
            {% endfor %}
        from pageviews_sessionized

    ),

    diffs as (

        select
            *,
            {{ dbt.datediff("session_start_tstamp", "session_end_tstamp", "second") }}
            as duration_in_s

        from agg

    ),

    tiers as (

        select

            *,

            case
                when duration_in_s between 0 and 9
                then '0s to 9s'
                when duration_in_s between 10 and 29
                then '10s to 29s'
                when duration_in_s between 30 and 59
                then '30s to 59s'
                when duration_in_s > 59
                then '60s or more'
            end as duration_in_s_tier

        from diffs

    ),

    channel_group as (
        select
            t.*,
            case
                when
                    t.utm_source is null and t.utm_medium is null and t.referrer is null
                then 'direct'
                when t.utm_medium is not null
                then lower(t.utm_medium)
                when rm.map_medium is not null and t.utm_medium is null
                then lower(rm.map_medium)
                when rm.map_medium is null and t.referrer like '%mezo.org%'
                then 'session_continue'
                else 'referral'
            end as referrer_medium,
            case
                when
                    t.utm_source is null and t.utm_medium is null and t.referrer is null
                then 'direct'
                when t.utm_source is not null
                then lower(t.utm_source)
                when rm.map_source is not null and t.utm_source is null
                then lower(rm.map_source)
                when t.referrer is not null
                then net.reg_domain(t.referrer)
            end as referrer_source

        from tiers as t
        left join referrer_mapping as rm on net.reg_domain(t.referrer) = rm.host_key
    )

select *
from channel_group
