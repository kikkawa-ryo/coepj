with

source as (select *, from {{ ref('base_nw__competition_results') }}),

flatten_table as (
    select
        program_key,
        program_id,
        offset,
        country,
        year,
        award_category,
        nw_competition_result,
    from
        source,
        unnest(
            json_query_array(nw_competition_results_array)
        ) as nw_competition_result
        with
        offset
)


select *,
from flatten_table
