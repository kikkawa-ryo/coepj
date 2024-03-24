{{ config(
    materialized="table"
) }}

with

flatten_table as (
    select * from {{ ref('base_coe__auction_results__flatten') }}
)

, get_columns as (
    select
        OFFSET,
        program_url,
        id,
        year,
        -- エイリアスとカラム名のペアをマクロで取得する
        {%- set columns_info = get_auction_results_columns() %}
        -- カラムの名寄せを行う
        {%- for columns_dict in columns_info.table %}
        case
            {%- for column in columns_dict.columns %}
            when coe_auciton_result.{{ column }}.text is not null then json_extract_scalar(coe_auciton_result.{{ column }}, "$.text")
            when coe_auciton_result.{{ column }} is not null then json_extract_scalar(coe_auciton_result, "{{'$.'~column}}")
            {%- endfor %}
            else null
        end as {{columns_dict.alias}}
        {%- if not loop.last %},{% endif -%}
        {% endfor %},
        coe_auciton_result.url,
        coe_auciton_result.individual_result,
    from
        flatten_table
)

select * from get_columns