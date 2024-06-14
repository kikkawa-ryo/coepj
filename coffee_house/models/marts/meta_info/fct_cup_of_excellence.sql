with
cup_of_excellence as (
    select
        program_key,
        country,
        year,
    from
        {{ ref('base_cup_of_excellence') }}      
)

select *, from cup_of_excellence
