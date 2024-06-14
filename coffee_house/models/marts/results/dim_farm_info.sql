with
tmp as (
    select
        result_key,
        program_key,
        farm_cws_competition,
        farmer_competition,
        farm_cws_auction,
        farmer_auction,
        farm_cws_commissions,
        farmer_commissions,
    from
        {{ ref('int_results_union_all_segments') }}      
)
select *, from tmp
