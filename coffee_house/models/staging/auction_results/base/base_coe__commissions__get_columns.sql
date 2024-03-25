{{ config(
    materialized="table"
) }}

with

flatten_table as (select *, from {{ ref('base_coe__commissions__flatten') }}),

get_columns as (
    select
        offset,
        program_url,
        id,
        year,
        -- エイリアスとカラム名のペアをマクロで取得する
        {%- set columns_info = get_commissions_columns() %}
        -- カラムの名寄せを行う
        {%- for columns_dict in columns_info.table %}
            case
                {%- for column in columns_dict.columns %}
                    when commissions.{{ column }}.text is not null
                        then
                            json_extract_scalar(
                                commissions.{{ column }}, "$.text"
                            )
                    when commissions.{{ column }} is not null
                        then json_extract_scalar(commissions, "{{ '$.'~column }}")
                {%- endfor %}
                else null
            end as {{ columns_dict.alias }}
            {%- if not loop.last %},{% endif -%}
        {% endfor %},
        commissions.url,
        commissions.individual_result,
    from flatten_table
)

select *,
from get_columns
