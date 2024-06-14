with
column_fixed_table as (
    select
        result_key,
        parse_json(
            replace(
                replace(
                    replace(
                        replace(
                            to_json_string(individual_result),
                            "Aroma / Flavor", "Aroma_Flavor"
                        ),
                        "Farm Name", "Farm_Name"
                    ),
                    "Farm Size", "Farm_Size"
                ),
                "Processing System", "Processing_System"
            )
        ) as individual_result
    from
        {{ ref('int_results_union_all_segments') }}
),
expanded_columns_table as (
    select
        result_key,
        {%- set columns_info = get_detail_results_columns() -%}
        {% for column_dict in columns_info.detail %}
        
        case
        {% if column_dict.previous %}
            when json_extract_scalar(individual_result, '$.detail.{{ column_dict.previous[0] }}') is not null
            then json_extract_scalar(individual_result, '$.detail.{{ column_dict.previous[0] }}')
        {% endif -%}
        {%- if column_dict.renewal %}
        {%- set category = column_dict.renewal[0].category -%}
        {%- set column = column_dict.renewal[0].column -%}
            when json_extract_scalar(individual_result, '$.{{ category }}.{{ column }}') is not null
            then json_extract_scalar(individual_result, '$.{{ category }}.{{ column }}')
        {% endif -%}
            else null
        end as {{ column_dict.alias }},
        {% endfor %}
        case
            when json_extract_scalar(individual_result, '$.location') is not null
                then json_extract_scalar(individual_result, '$.location')
            else null
        end as location,
        case
            when json_extract_scalar(individual_result, '$.similar_farm') is not null
                then json_extract_scalar(individual_result, '$.similar_farm')
            else null
        end as similar_farm,
    from
        column_fixed_table
)
select *, from expanded_columns_table
