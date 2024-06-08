with

source as (select *, from {{ ref('base_coe__commissions') }}),

flatten_table as (
    select
        offset,
        country,
        year,
        program_key,
        award_category,
        commissions,
    from
        source,
        unnest(json_query_array(commissions_array)) as commissions
        with
        offset
)

select *,
from flatten_table
