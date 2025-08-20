{{
    dbt_utils.union_relations(
        relations=[
            ref("stg_segment_profiles__tracks"),
            ref("stg_segment_profiles__pages"),
        ]
    )
}}
