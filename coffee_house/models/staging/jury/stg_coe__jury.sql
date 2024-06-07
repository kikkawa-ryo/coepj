with

base_table as (select *, from {{ ref('base_coe__jury__expand_columns') }}),

final as (
    select
        offset,
        country,
        year,
        program,
        judge_stage,
        jury_name,
        jury_organization,
        jury_country,
        jury_province,
        jury_role,
        jury_group,
        span,
        assigned_stage,
    from
        base_table
)

select *,
from final
