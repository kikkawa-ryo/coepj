with
cup_of_excellence as (
    select
        result_key,
        program_key,
        award_category,
    from
        {{ ref('int_results_union_all_segments') }}      
)

select *, from cup_of_excellence
