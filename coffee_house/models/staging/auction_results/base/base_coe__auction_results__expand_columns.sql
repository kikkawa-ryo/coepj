{{ config(
    materialized="table"
) }}

with

flatten_table as (
    select *, from {{ ref('base_coe__auction_results__flatten') }}
),

get_columns as (
    select
        program_key,
        program_id,
        offset,
        country,
        year,
        award_category,
        {%- set columns_info = get_auction_results_columns() %}
        {%- for columns_dict in columns_info.coe %}
            case
                {%- for column in columns_dict.columns %}
                    when coe_auciton_result.{{ column }} is not null
                        then
                            json_extract_scalar(
                                coe_auciton_result, "{{ '$.'~column }}"
                            )
                {%- endfor %}
                else null
            end as {{ columns_dict.alias }}
            {%- if not loop.last %},{% endif -%}
        {% endfor %},
        if(coe_auciton_result.weight_kg_ is not null, "kg", "lb")
            as weight_unit,
        json_extract_scalar(coe_auciton_result, "$.span") as span,
        json_extract_scalar(coe_auciton_result, "$.url") as url,
        coe_auciton_result.individual_result,
    from flatten_table
)

select *,
from get_columns
