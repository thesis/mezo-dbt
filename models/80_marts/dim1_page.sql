with
    segment_sessions as (select * from {{ ref("int_segment__sessions") }}),

    all_pages as (
        select exit_page_url_without_query_string as id
        from segment_sessions
        union all
        select landing_page_url_without_query_string as id
        from segment_sessions
    )

select distinct id
from all_pages
