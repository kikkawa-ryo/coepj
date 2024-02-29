with

source as (
    select * from {{ ref('stg_coe_results') }}
)

, coe_auction_results as (
    select
        url,
        case
            when contents.COE_Auction_Results is not null then contents.COE_Auction_Results
            else null
        end as coe_auction_results_array
    from
        source
)

, final as (
    select
        * except(coe_auction_results_array)
    from
        coe_auction_results
        , unnest(json_query_array(coe_auction_results_array)) as coe_auction_result
)

select * from final