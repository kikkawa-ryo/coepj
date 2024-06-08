with

source as (select *, from {{ ref('base_coe__auction_results') }}),

flatten_table as (
    select
        offset,
        country,
        year,
        program_key,
        award_category,
        coe_auciton_result,
    from
        source,
        unnest(json_query_array(coe_auction_results_array))
            as coe_auciton_result
        with
        offset
)

select *,
from flatten_table
