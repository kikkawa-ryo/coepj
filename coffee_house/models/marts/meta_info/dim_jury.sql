with
judge as (
    select
        program,
        judge_stage,
        jury_name,
        jury_organization,
        jury_role,
        jury_group,
        assigned_stage,
    from
        {{ ref('stg_coe__jury') }}      
)

select *, from judge
