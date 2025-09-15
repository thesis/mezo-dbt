with
    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    )

select *
from first_touch_point
