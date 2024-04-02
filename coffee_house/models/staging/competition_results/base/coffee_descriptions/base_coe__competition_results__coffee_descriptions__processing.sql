{{ config(
    materialized="table"
) }}

with

raw_table as (
    select *, from {{ ref("base_coe__competition_results__json_to_table") }}
),

pre_processing_0 as (
    select
        id,
        "acidity" as attributes,
        normalize(acidity_detail, nfkc) as description_str,
    from raw_table
    union all
    select
        id,
        "aroma_flavor" as attributes,
        normalize(aroma_flavor_detail, nfkc) as description_str,
    from raw_table
    union all
    select
        id,
        "other" as attributes,
        normalize(other_detail, nfkc) as description_str,
    from raw_table
    union all
    select
        id,
        "overall" as attributes,
        normalize(overall_detail, nfkc) as description_str,
    from raw_table
    union all
    select
        id,
        "characteristics" as attributes,
        normalize(coffee_characteristics_detail, nfkc) as description_str,
    from raw_table
)
{%- set fix_dict_list = get_normalize_dict() + get_preprocess_dict() + get_translate_dict() -%}
{% for fix_dict in fix_dict_list %}
    {% set before_index = loop.index0 |string -%}
    {% set current_index = loop.index |string -%},
    {{ "pre_processing_" ~ current_index }} as (
        select
            id,
            attributes,
            regexp_replace(
                description_str,
                r"{{ fix_dict.regexp }}",
                "{{ fix_dict.replacement }}"
            ) as description_str,
        from {{ "pre_processing_" ~ before_index }}
    )
    {%- if loop.last %}

        , pre_processing as (
            select *, from {{ "pre_processing_" ~ current_index }}
        )
    {% endif -%}
{% endfor -%},
process_for_array as (
    select
        -- .の処理が甘い
        id,
        attributes,
        regexp_replace(
            description_str, r";|\W\.\W|\.$|\.\s|\.", ","
        ) as description_str,
    from pre_processing
),

str2arr as (
    select
        id,
        attributes,
        split(description_str, ",") as description_arr,
    from process_for_array
),

flatten as (
    select
        id,
        attributes,
        description_str,
    from str2arr, unnest(description_arr) as description_str
),

duplicating as (
    select
        id,
        attributes,
        case
            when regexp_contains(description_str, r"\(\s*\d+\s*\)?|x\d+")
                then
                    rtrim(
                        repeat(
                            regexp_replace(
                                description_str, r"\(\s*\d+\s*\)?|x\d+", ","
                            ),
                            cast(
                                regexp_extract(description_str, r"\d+") as int64
                            )
                        ),
                        ","
                    )
            else description_str
        end as description_str,
    from flatten
),

processing_0 as (
    select
        id,
        attributes,
        trim(trim(lower(description_str), ",")) as description_str,
    from duplicating, unnest(split(description_str, ",")) as description_str
)
{%- set fix_dict_list = get_translate_dict() + get_process_dict() -%}
{% for fix_dict in fix_dict_list %}
    {% set before_index = loop.index0 |string -%}
    {% set current_index = loop.index |string -%},
    {{ "processing_" ~ current_index }} as (
        select
            id,
            attributes,
            {%- if fix_dict.conditions %}
                case
                    when
                    {# 条件 #}
                        {%- for condition in fix_dict.conditions -%}
                            {%- if condition.type == "contains" -%}
                                regexp_contains(
                                    description_str, r"{{ condition.pattern }}"
                                )
                            {% endif -%}
                            {%- if condition.type == "count" -%}
                                array_length(
                                    regexp_extract_all(
                                        description_str,
                                        r"{{ condition.pattern }}"
                                    )
                                ) {{ condition.sign }} {{ condition.n }}
                            {% endif -%}
                            {%- if not loop.last -%} and {% endif -%}
                            {%- if loop.last -%}
                                {# value #}
                                then
                                    regexp_replace(
                                        description_str,
                                        r"{{ fix_dict.regexp }}",
                                        "{{ fix_dict.replacement }}"
                                    )
                            {%- endif %}
                        {%- endfor %}
                    else description_str
                end as description_str
            {%- else %}
                regexp_replace(
                    description_str,
                    r"{{ fix_dict.regexp }}",
                    "{{ fix_dict.replacement }}"
                ) as description_str,
            {% endif %}
        from {{ "processing_" ~ before_index }}
    )

    {%- if loop.last %}
        ,
        processing as (
            select
                id,
                attributes,
                regexp_replace(
                    regexp_replace(description_str, r"^[\s,]+|[\s,]+$", ""),
                    r"\s*,\s*,*",
                    ","
                ) as description_str,
            from {{ "processing_" ~ current_index }}
        )
    {% endif -%}
{% endfor -%},
aggregating as (
    select
        processing.id,
        processing.attributes,
        string_agg(processing.description_str, ",") as description_str_agg,
        max(pre_processing_0.description_str) as description_str_raw,
    from processing
    left join
        pre_processing_0
        on
            processing.id = pre_processing_0.id
            and processing.attributes = pre_processing_0.attributes
    group by id, attributes
),

fillna as (
    select
        id,
        attributes,
        if(
            description_str_agg != "", description_str_agg, null
        ) as description_str_agg,
        if(
            description_str_raw != "", description_str_raw, null
        ) as description_str_raw,
    from aggregating
),

final as (
    select
        id,
        any_value(
            if(attributes = "acidity", description_str_agg, null)
        ) as acidity_str_agg,
        any_value(
            if(attributes = "aroma_flavor", description_str_agg, null)
        ) as aroma_flavor_str_agg,
        any_value(
            if(attributes = "other", description_str_agg, null)
        ) as other_str_agg,
        any_value(
            if(attributes = "overall", description_str_agg, null)
        ) as overall_str_agg,
        any_value(
            if(attributes = "characteristics", description_str_agg, null)
        ) as characteristics_str_agg,
        any_value(
            if(attributes = "acidity", description_str_raw, null)
        ) as acidity_str_raw,
        any_value(
            if(attributes = "aroma_flavor", description_str_raw, null)
        ) as aroma_flavor_str_raw,
        any_value(
            if(attributes = "other", description_str_raw, null)
        ) as other_str_raw,
        any_value(
            if(attributes = "overall", description_str_raw, null)
        ) as overall_str_raw,
        any_value(
            if(attributes = "characteristics", description_str_raw, null)
        ) as characteristics_str_raw,
    from fillna
    group by id
    order by id desc
)

select *,
from final
