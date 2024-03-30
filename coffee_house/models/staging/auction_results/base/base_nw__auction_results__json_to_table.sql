{{ config(
    materialized="table"
) }}

with

flatten_table as (
    select *, from {{ ref('base_nw__auction_results__flatten') }}
),

get_columns as (
    select
        id,
        offset,
        country,
        year,
        program,
        award_category,
        {%- set columns_info = get_auction_results_columns() %}
        {%- for columns_dict in columns_info.nw %}
            case
                {%- for column in columns_dict.columns %}
                    when nw_auciton_result.{{ column }} is not null
                        then
                            json_extract_scalar(
                                nw_auciton_result, "{{ '$.'~column }}"
                            )

                {%- endfor %}
                else null
            end as {{ columns_dict.alias }}
            {%- if not loop.last %},{% endif -%}
        {% endfor %},
        if(nw_auciton_result.Weight_Kg_ is not null, "kg", "lb") as weight_unit,
        nw_auciton_result.span,
        nw_auciton_result.url,
        nw_auciton_result.individual_result,
    from flatten_table
)

select *,
from get_columns
