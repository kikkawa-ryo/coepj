with
joined_table as (
    select *, from {{ ref('int_results_segment_majority') }}
    union all
    select *, from {{ ref('int_results_segment_more_auction_than_competition') }}
    union all
    select *, from {{ ref('int_results_segment_more_competition_than_auction_and_not_have_rank') }}
    union all
    select *, from {{ ref('int_results_segment_more_competition_than_auction') }}
)
select *, from joined_table
