with

source as (
    select * from {{ ref('stg_coe_results') }}
)

, nw_auction_results as (
    select
        url,
        case
            when contents.NW_Auction_Results is not null then contents.NW_Auction_Results
            else null
        end as nw_auction_results_array
    from
        source
)

, final as (
    select
        * except(nw_auction_results_array)
    from
        nw_auction_results
        , unnest(json_query_array(nw_auction_results_array)) as nw_auction_result
)

select * from final