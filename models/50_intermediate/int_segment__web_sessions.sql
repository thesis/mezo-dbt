with
    web_sessions as (select * from {{ ref("segment_web_sessions") }}),

    channel_grouping as (
        select
            web_sessions.*, case when web_sessions = "" then "" end as channelgrouping
        from web_sessions
    )

select *
from channel_grouping
