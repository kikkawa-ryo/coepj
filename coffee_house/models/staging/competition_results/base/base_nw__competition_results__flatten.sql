with

source as (select *, from {{ ref('base_nw__competition_results') }}),

flatten_table as (
    select
        offset,
        country,
        year,
        program,
        award_category,
        nw_competition_result,
        concat(program, '_', award_category, "_", offset) as id,
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
