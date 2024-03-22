{{
  config(
    materialized='table'
  )
}}

with

source as (
  select * from {{ source('staging', 'coe_results') }}
)

, tmp as (
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
  from tmp
)

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

select * from final