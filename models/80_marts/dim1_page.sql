with
    segment_sessions as (select * from {{ ref("int_segment__sessions") }}),

    all_pages as (
        select exit_page_url_without_query_string as id
        from segment_sessions
        where exit_page_url_without_query_string is not null
        union all
        select landing_page_url_without_query_string as id
        from segment_sessions
        where landing_page_url_without_query_string is not null
    ),

    make_unique as (
        select id
        from all_pages
        qualify row_number() over (partition by id order by id) = 1
    )

select *
from make_unique
