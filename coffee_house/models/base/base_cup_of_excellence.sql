with
    source as (select * from {{ source('staging', 'cup_of_excellence') }}),
    deduplicated as (
        select url, array_agg(s order by s.url desc limit 1)[offset(0)] contents
        from source s
        group by url
    ),
    final as (select contents.* from deduplicated)

select *
from final
