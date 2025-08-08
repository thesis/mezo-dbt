with
    source as (select * from {{ source("raw_segment_profiles", "user_identifiers") }}),

    renamed as (
        select
            __profile_version,
            canonical_segment_id,
            id,
            loaded_at,
            received_at,
            seq,
            type,
            uuid_ts,
            value

        from source
    )

select *
from renamed
