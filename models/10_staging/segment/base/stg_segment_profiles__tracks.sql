with
    source as (select * from {{ source("raw_segment_profiles", "tracks_view") }}),

    renamed as (
        select
            context_ip,
            context_library_name,
            context_library_version,
            context_locale,
            context_page_path,
            context_page_referrer,
            context_page_search,
            context_page_title,
            context_page_url,
            context_protocols_source_id,
            context_protocols_violations,
            context_timezone,
            context_user_agent,
            context_user_agent_data_brands,
            context_user_agent_data_mobile,
            context_user_agent_data_platform,
            event as event_name,
            event_source_id,
            event_source_name,
            event_source_slug,
            event_text,
            id,
            loaded_at,
            original_timestamp,
            received_at,
            segment_id,
            sent_at,
            timestamp,
            user_id,
            uuid_ts,
            anonymous_id,
            context_campaign_content,
            context_campaign_medium,
            context_campaign_name,
            context_campaign_source,
            context_campaign_term,
            context_event_transformed,
            context_transforms_beta,
            net.host(context_page_url) as hostname,
            net.reg_domain(context_page_url) as registered_domain
        from source
    ),

    filter_irrelevant_data as (
        select *
        from renamed
        where registered_domain = 'mezo.org' and anonymous_id is not null
    )

select *
from filter_irrelevant_data
