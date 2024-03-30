{{ config(
    materialized="table"
) }}

with

flatten_table as (select *, from {{ ref('base_coe__commissions__flatten') }}),

get_columns as (
    select
        id,
        offset,
        country,
        year,
        program,
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
        commissions.span,
        commissions.url,
        commissions.individual_result,
    from flatten_table
)

select *,
from get_columns
