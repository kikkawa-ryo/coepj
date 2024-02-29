-- depends_on: {{ ref('base_cup_of_excellence__coe_results_coffee_descriptions_ngram_split') }} 

{# {{ config(
    materialized="table"
) }} #}

{# with

processing as (
    select * from {{ ref("base_cup_of_excellence__coe_results_coffee_descriptions_ngram_split") }}
)

, concat as (
    select distinct
        acidity_str_mini_unit unit,
    from
        processing
        , unnest(SPLIT(acidity_str_agg, ",")) as acidity_str_mini_unit
    union all
    select distinct
        aroma_flavor_str_mini_unit,
    from
        processing
        , unnest(SPLIT(aroma_flavor_str_agg, ",")) as aroma_flavor_str_mini_unit
    union all
    select distinct
        other_str_mini_unit,
    from
        processing
        , unnest(SPLIT(other_str_agg, ",")) as other_str_mini_unit
    union all
    select distinct
        overall_str_mini_unit,
    from
        processing
        , unnest(SPLIT(overall_str_agg, ",")) as overall_str_mini_unit
    union all
    select distinct
        characteristics_str_mini_unit,
    from
        processing
        , unnest(SPLIT(characteristics_str_agg, ",")) as characteristics_str_mini_unit
)
, final as (
    select
        unit
    from
        concat
) #}
{%- set ngrams = get_replaceable_bigram(model="base_cup_of_excellence__coe_results_coffee_descriptions_ngram_split") -%}
select
{% for ngram in ngrams %}
"{{ngram}}",
{% endfor %}