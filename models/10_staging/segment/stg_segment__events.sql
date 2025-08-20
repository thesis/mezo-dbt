with
    events as (select * from {{ ref("stg_segment__union_events") }}),

    calculated_fields as (
        select
            *,
            {{ dbt_utils.get_url_parameter("page_url", "gclid") }} as gclid,
            case
                when lower(user_agent) like '%android%'
                then 'Android'
                else
                    replace(
                        {{
                            dbt.split_part(
                                dbt.split_part("user_agent", "'('", 2),
                                "' '",
                                1,
                            )
                        }},
                        ';',
                        ''
                    )
            end as device
        from events
    ),

    final as (
        select
            *,
            case
                when device = 'iPhone'
                then 'iPhone'
                when device = 'Android'
                then 'Android'
                when device in ('iPad', 'iPod')
                then 'Tablet'
                when device in ('Windows', 'Macintosh', 'X11')
                then 'Desktop'
                else 'Uncategorized'
            end as device_category
        from calculated_fields
    )

select *
from final
