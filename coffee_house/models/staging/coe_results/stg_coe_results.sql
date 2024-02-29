{{
  config(
    materialized='table'
  )
}}

with

source as (
  select * from {{ source('staging', 'coe_results') }}
)

, identify_url as (
  SELECT 
    url
    , ARRAY_AGG(s LIMIT 1)[OFFSET(0)] contents
  FROM
    source s
  GROUP BY
    url
)

, final as (
  select
    contents.*
  from identify_url
)

select * from final