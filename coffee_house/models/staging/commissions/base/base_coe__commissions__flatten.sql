with

source as (select *, from {{ ref('base_coe__commissions') }}),

flatten_table as (
    select
        program_key,
        program_id,
        offset,
        country,
        year,
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
