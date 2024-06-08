with
joined_table as (
    select *, from {{ ref('int_results_segment_majority') }}
    union all
    select *, from {{ ref('int_results_segment_more_auction_than_competition') }}
    union all
    select *, from {{ ref('int_results_segment_more_competition_than_auction_and_not_have_rank') }}
    union all
    select *, from {{ ref('int_results_segment_more_competition_than_auction') }}
),
final as (
    select
        FARM_FINGERPRINT(result_id) as result_key,
        *,
    from
        joined_table

)
select *, from final
