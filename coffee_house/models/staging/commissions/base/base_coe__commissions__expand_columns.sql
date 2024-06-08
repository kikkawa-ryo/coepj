{{ config(
    materialized="table"
) }}

with

flatten_table as (select *, from {{ ref('base_coe__commissions__flatten') }}),

expanded_table as (
    select
        offset,
        country,
        year,
        program_key,
        award_category,
        {%- set columns_info = get_commissions_columns() %}
        {%- for columns_dict in columns_info %}
            case
                {%- for column in columns_dict.columns %}
                    when commissions.{{ column }} is not null
                        then
                            json_extract_scalar(
                                commissions, "{{ '$.'~column }}"
                            )
                {%- endfor %}
                else null
            end as {{ columns_dict.alias }}
            {%- if not loop.last %},{% endif -%}
        {% endfor %},
        if(commissions.weight_kg_ is not null, "kg", "lb")as weight_unit,
        json_extract_scalar(commissions, "$.span") as span,
        json_extract_scalar(commissions, "$.url") as url,
        commissions.individual_result,
    from flatten_table
)

select *,
from expanded_table
