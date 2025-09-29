{{
    dbt_utils.union_relations(
        relations=[
            ref("fct_assets_locked"),
            ref("fct_donated"),
            ref("fct_liquidation"),
            ref("fct_loans"),
            ref("fct_orders"),
            ref("fct_paid"),
            ref("fct_sessions"),
        ],
        column_override={"id": "STRING"},
    )
}}
