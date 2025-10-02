with
    facts as (select * from {{ ref("fct_all_facts") }}),

    attribution as (select * from {{ ref("dim1_attribution") }}),

    campaign as (select * from {{ ref("dim1_campaign") }}),

    products as (select * from {{ ref("dim1_products") }}),

    token as (select * from {{ ref("dim1_token") }}),

    final as (
        select
            facts.*, a.* except (id), c.* except (id), pr.* except (id), t.* except (id)
        from facts
        left join attribution as a on facts.fk__dim1_attribution = a.id
        left join campaign as c on facts.fk__dim1_campaign = c.id
        left join products as pr on facts.fk__dim1_products = pr.id
        left join token as t on facts.fk__dim1_token = t.id
    )

select *
from final
