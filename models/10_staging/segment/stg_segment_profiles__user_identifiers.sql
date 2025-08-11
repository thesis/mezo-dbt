with
    source as (select * from {{ source("raw_segment_profiles", "user_identifiers") }}),

    renamed as (
        select
            __profile_version as _profile_version,
            canonical_segment_id,
            id,
            loaded_at,
            received_at,
            seq as seq_id,
            type as id_type,
            uuid_ts,
            value as trait_value
        from source
    )

select *
from renamed
