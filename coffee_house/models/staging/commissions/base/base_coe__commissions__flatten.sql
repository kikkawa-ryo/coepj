with

source as (select *, from {{ ref('base_coe__commissions') }}),

flatten_table as (
    select
        offset,
        country,
        year,
        program,
        award_category,
        commissions,
        concat(program, '_', award_category, "_", offset) as id,
    from
        source,
        unnest(json_query_array(commissions_array)) as commissions
        with
        offset
)

select *,
from flatten_table
