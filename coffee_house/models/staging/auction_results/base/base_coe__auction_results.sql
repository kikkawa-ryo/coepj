{{
  config(
    materialized='view'
  )
}}

with

source as (
  select * from {{ ref('base_cup_of_excellence') }}
)

, coe_auciton_results as (
    select
        url,
        contents.COE_Auction_Results as coe_auction_results_array
    from
        source
)

select * from coe_auciton_results