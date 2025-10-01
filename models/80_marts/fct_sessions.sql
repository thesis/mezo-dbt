with
    segment_sessions as (select * from {{ ref("int_segment__sessions") }}),

    facts as (
        select
            session_id as id,
            canonical_segment_id_with_fallback as fk__dim1_users,
            referrer_id as fk__dim1_attribution,
            session_start_date as record_date,
            campaign_id as fk__dim1_campaign,
            landing_page_url_without_query_string as fk_landingpage__dim1_page,
            exit_page_url_without_query_string as fk_exitpage__dim1_page,
            {% for session_metric in var("session_metrics") %}
                {{ session_metric.metric_name }}{{ "," if not loop.last }}
            {% endfor %},
            duration_in_s as session_duration_in_seconds
        from segment_sessions
    )

select *
from facts
