with
    source as (select * from {{ source("raw_segment_profiles", "pages_view") }}),

    renamed as (
        select
            context_campaign_source as utm_source,
            context_campaign_medium as utm_medium,
            context_campaign_name as utm_campaign,
            context_campaign_term as utm_term,
            context_campaign_content as utm_content,
            context_campaign_id as utm_id,
            context_ip as ip,
            context_library_name as library_name,
            context_library_version,
            context_locale,
            context_page_path as page_url_path,
            context_page_referrer,
            context_page_search,
            context_page_title,
            context_page_url,
            context_protocols_source_id,
            context_timezone,
            context_user_agent as user_agent,
            context_user_agent_data_brands,
            context_user_agent_data_mobile,
            context_user_agent_data_platform,
            event_source_id,
            event_source_name as source_name,
            event_source_slug,
            id,
            loaded_at,
            original_timestamp,
            'page_view' as event_name,
            path as page_path,
            received_at as received_at_tstamp,
            referrer,
            search as page_url_query,
            segment_id,
            sent_at,
            timestamp as tstamp,
            title as page_title,
            url as page_url,
            user_id,
            uuid_ts,
            anonymous_id,
            context_actions_amplitude_session_id,
            net.host(context_page_url) as page_url_host,
            net.host(referrer) as referrer_host,
            net.reg_domain(context_page_url) as registered_domain
        from source
    ),

    filter_irrelevant_data as (
        select *
        from renamed
        where registered_domain = 'mezo.org' and anonymous_id is not null
        qualify
            row_number() over (
                partition by source_name, id order by received_at_tstamp asc
            )
            = 1
    )

select *
from filter_irrelevant_data
