with

source as (select *, from {{ ref('base_nw__auction_results') }}),

flatten_table as (
    select
        offset,
        country,
        year,
        program,
        award_category,
        nw_auciton_result,
        concat(program, '_', award_category, "_", offset) as id,
    from
        source,
        unnest(json_query_array(nw_auction_results_array))
            as nw_auciton_result
        with
        offset
)

select *,
from flatten_table
