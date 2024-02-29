with target_table as (
    SELECT
        id,
        acidity_str_raw, aroma_flavor_str_raw, other_str_raw, overall_str_raw, characteristics_str_raw,
        acidity_str_agg, aroma_flavor_str_agg, other_str_agg, overall_str_agg, characteristics_str_agg
    FROM
        {{ ref("base_cup_of_excellence__coe_results_coffee_descriptions_processing") }}
)

, step0 as (
    select
        id,
        "acidity" as attributes,
        acidity_str_agg as description_str_agg,
    from
        target_table
    union all
    select
        id,
        "aroma_flavor",
        aroma_flavor_str_agg,
    from
        target_table
    union all
    select
        id,
        "other",
        other_str_agg,
    from
        target_table
    union all
    select
        id,
        "overall",
        overall_str_agg,
    from
        target_table
    union all
    select
        id,
        "characteristics" as attributes,
        characteristics_str_agg,
    from
        target_table
)

{%- set ngrams = get_topx_ngram(threshold=30, n=2) -%}
{% for ngram in ngrams %}
{% set before_index = loop.index0 |string -%}
{% set current_index = loop.index |string -%}
, {{ "step" ~ current_index }} as (
    select
        id,
        attributes,
        REGEXP_REPLACE(description_str_agg, r"\b({{ ngram }})\b", ",\\1,") as description_str_agg
    from
        {{ "step" ~ before_index }}
)
{%- if loop.last %}
, processed as (
    select
        id,
        attributes,
        REGEXP_REPLACE(REGEXP_REPLACE(description_str_agg, r"[\s,]{2,}", ","), r"^,|,$", "") AS description_str_agg,
    from
        {{ "step" ~ current_index }}
)
{% endif -%}
{% endfor %}

, aggregating as (
    select
        id,
        ANY_VALUE(description_str_agg HAVING MAX length(if(attributes = "acidity", description_str_agg, ""))) as acidity_str_agg,
        ANY_VALUE(description_str_agg HAVING MAX length(if(attributes = "aroma_flavor", description_str_agg, ""))) as aroma_flavor_str_agg,
        ANY_VALUE(description_str_agg HAVING MAX length(if(attributes = "other", description_str_agg, ""))) as other_str_agg,
        ANY_VALUE(description_str_agg HAVING MAX length(if(attributes = "overall", description_str_agg, ""))) as overall_str_agg,
        ANY_VALUE(description_str_agg HAVING MAX length(if(attributes = "characteristics", description_str_agg, ""))) as characteristics_str_agg,
    from
        processed
    group by
        id
)

, final as (
    select
        aggregating.id,
        aggregating.acidity_str_agg,
        aggregating.aroma_flavor_str_agg,
        aggregating.other_str_agg,
        aggregating.overall_str_agg,
        aggregating.characteristics_str_agg,
        target_table.acidity_str_raw,
        target_table.aroma_flavor_str_raw,
        target_table.other_str_raw,
        target_table.overall_str_raw,
        target_table.characteristics_str_raw,
    from
        aggregating
    left join target_table
        on aggregating.id = target_table.id
)

select * from final