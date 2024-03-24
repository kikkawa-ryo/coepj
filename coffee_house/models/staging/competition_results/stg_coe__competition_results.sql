{{
  config(
    materialized='table'
  )
}}

with

    source as (select * from {{ source('staging', 'coe_results') }}),
    tmp as (
        select url, array_agg(s order by s.url desc limit 1)[offset(0)] contents
        from source s
        group by url
    ),
    final as (select contents.* from tmp)

{# , indexing as (
  select
    *
    , row_number()
      over(order by url)
      as refId
  from source
)

, final as (
  select
    * except(refId)
  from indexing
  where
    refId in (select max(refId) from indexing group by url)
) #}
select *
from final
