with

source as (select *, from {{ ref('base_coe__jury') }}),

flatten_table as (
    select
        offset,
        program_url,
        year,
        program,
        judge_stage,
        jury,
    from
        source, unnest(json_query_array(jury_array)) as jury
    with offset
)

select *, from flatten_table
