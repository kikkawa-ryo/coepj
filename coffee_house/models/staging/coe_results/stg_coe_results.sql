{{
  config(
    materialized='table'
  )
}}

with

source as (
  select * from {{ source('staging', 'coe_results') }}
)

, indexing as (
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
)

select * from final