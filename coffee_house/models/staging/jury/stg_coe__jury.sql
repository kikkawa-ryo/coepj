with

base_table as (select *, from {{ ref('base_coe__jury__expand_columns') }}),

final as (
    select
        FARM_FINGERPRINT(concat(program_id, '_', judge_stage, '_', offset)) as jury_key,
        concat(program_id, '_', judge_stage, '_', offset) as jury_id,
        program_key,
        program_id,
        offset,
        country,
        year,
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
