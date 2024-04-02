with

source as (select *, from {{ ref('base_coe__competition_results') }}),

flatten_table as (
    select
        0 as is_fixed,
        offset,
        country,
        year,
        program,
        award_category,
        coe_competition_result,
    from
        source,
        unnest(
            json_query_array(coe_competition_results_array)
        ) as coe_competition_result
        with
        offset
),

concat_table as (
    select *,
    from flatten_table
    union all
    select *,
    from {{ ref('seed_coe__competition_results__fixed_data') }}
),

filtered_table as (
    select
        offset,
        country,
        year,
        program,
        award_category,
        coe_competition_result,
        concat(program, '_', award_category, "_", offset) as id,
    from concat_table
    -- 修正前データを削除
    qualify rank() over (partition by offset, program order by is_fixed desc) = 1
    order by
        program,
        offset
)

select *,
from filtered_table
