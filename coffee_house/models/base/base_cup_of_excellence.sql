with source as (
      select * from {{ source('staging', 'cup_of_excellence') }}
)

, deduplicated as (
  SELECT 
    url
    , ARRAY_AGG(s ORDER BY s.url DESC LIMIT 1)[OFFSET(0)] contents
  FROM
    source s
  GROUP BY
    url
)

, final as (
  select
    contents.*
  from deduplicated
)

select * from final
  