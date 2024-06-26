with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

international_jury as (
    select
        program_key,
        program_id,
        country,
        year,
        "international" as judge_stage,
        json_extract(contents, "$.International_Jury") as jury_array,
    from source
),

national_jury as (
    select
        program_key,
        program_id,
        country,
        year,
        "national" as judge_stage,
        json_extract(contents, "$.National_Jury") as jury_array,
    from source
),

jury as (
    select *, from international_jury
    union all
    select *, from national_jury
)

select *, from jury
