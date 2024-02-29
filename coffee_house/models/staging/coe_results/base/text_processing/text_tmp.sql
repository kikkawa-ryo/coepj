{{ config(
    materialized="table"
) }}

with

processing as (
    select * from {{ ref("base_cup_of_excellence__coe_results_coffee_descriptions_ngram_split") }}
)

, concat as (
    select distinct
        acidity_str_raw raw,
        acidity_str_mini_unit unit,
    from
        processing
        , unnest(SPLIT(acidity_str_agg, ",")) as acidity_str_mini_unit
    union all
    select distinct
        aroma_flavor_str_raw,
        aroma_flavor_str_mini_unit,
    from
        processing
        , unnest(SPLIT(aroma_flavor_str_agg, ",")) as aroma_flavor_str_mini_unit
    union all
    select distinct
        other_str_raw,
        other_str_mini_unit,
    from
        processing
        , unnest(SPLIT(other_str_agg, ",")) as other_str_mini_unit
    union all
    select distinct
        overall_str_raw,
        overall_str_mini_unit,
    from
        processing
        , unnest(SPLIT(overall_str_agg, ",")) as overall_str_mini_unit
)
, final as (
    select
        unit,
        raw
    from
        concat
)

select * from final