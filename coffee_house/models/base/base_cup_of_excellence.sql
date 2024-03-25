with
source as (select *, from {{ source('staging', 'cup_of_excellence') }}),

deduplicated as (
    select
        url,
        array_agg(s order by s.url desc limit 1)[offset(0)] as contents,
    from source as s
    group by url
),

final as (select contents.*, from deduplicated)

select *,
from final
