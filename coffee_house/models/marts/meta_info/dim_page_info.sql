with
judge as (
    select
        program,
        remarks,
        description,
    from
        {{ ref('stg_coe__page_info') }}      
)

select *, from judge
