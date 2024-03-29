{{ config(
    materialized="table"
) }}

with

    flatten_table as (
        select * from {{ ref('base_coe__competition_results__flatten') }}
    ),
    get_columns as (
        select
            offset,
            program_url,
            id,
            year,

            -- エイリアスとカラム名のペアをマクロで取得する
            {%- set columns_info = get_competition_results_columns() -%}
            -- カラムの名寄せを行う
            {% for columns_dict in columns_info.table %}
                case
                    {%- for column in columns_dict.columns %}
                        when coe_competition_result.{{ column }}.text is not null
                        then
                            json_extract_scalar(
                                coe_competition_result.{{ column }}, "$.text"
                            )
                        when coe_competition_result.{{ column }} is not null
                        then
                            json_extract_scalar(
                                coe_competition_result, "{{'$.'~column}}"
                            )
                    {%- endfor %}
                    else null
                end as {{ columns_dict.alias + "_table" }}
                {%- if not loop.last %},{% endif -%}
            {% endfor %},

            -- カラム名の情報をフラグ化して引き継ぐ
            case
                when coe_competition_result.farm_cws is not null
                then true
                when coe_competition_result.farm___cws is not null
                then true
                when coe_competition_result.farm___cws is not null
                then true
                else false
            end as is_cws,
            case
                when coe_competition_result.farmer___organization is not null
                then "organization"
                when coe_competition_result.farmer___representative is not null
                then "representative"
                when coe_competition_result.farmer___representative is not null
                then "representative"
                when coe_competition_result.producer is not null
                then "producer"
                when coe_competition_result.producer is not null
                then "producer"
                when coe_competition_result.owner is not null
                then "owner"
                else "none"
            end as rep_org_flg,
            case
                when coe_competition_result.size__30kg_boxes_ is not null
                then true
                when coe_competition_result.size__30kg_boxes_ is not null
                then true
                else false
            end as is_size_30kg_boxes,
            case
                when coe_competition_result.weight__kg_ is not null
                then "kg"
                when coe_competition_result.weight__kg_ is not null
                then "kg"
                when coe_competition_result.weight__kg_ is not null
                then "kg"
                when coe_competition_result.weight_lbs_ is not null
                then "lbs"
                when coe_competition_result.weight___lbs is not null
                then "lbs"
                else "none"
            end as weight_kg_lbs_flg,
            -- 個別ページに関する情報をjson形式から展開
            -- individual result
            json_extract_scalar(coe_competition_result, '$.url') as individual_url,
            coe_competition_result.individual_result.description
            as individual_description,
            case
                when
                    if(coe_competition_result.farm_information is not null, true, false)
                then "renewal"
                else "previous"
            end as site_flg,

            -- カラムの名寄せを行う
            {% for columns_dict in columns_info.detail %}
                case
                    {# 過去サイト -#}
                    {% for column in columns_dict.previous %}
                        {%- if column -%}
                            {%- if column in ["images"] -%}
                                when
                                    coe_competition_result.individual_result.detail.{{ column }}
                                    is not null
                                then
                                    coe_competition_result.individual_result.detail.{{ column }}
                            {% else %}
                                when
                                    coe_competition_result.individual_result.detail.{{ column }}
                                    is not null
                                then
                                    string(
                                        coe_competition_result.individual_result.detail.{{ column }}
                                    )
                            {%- endif -%}
                        {%- endif -%}
                    {% endfor %}
                    {# リニューアルサイト #}
                    {% for column_info in columns_dict.renewal %}
                        {%- if column_info -%}
                            {%- if column_info.category in ["gallery", "location", "similar_farm"] -%}
                                when
                                    coe_competition_result.individual_result.{{ column_info.category }}
                                    is not null
                                then
                                    coe_competition_result.individual_result.{{ column_info.category }}
                            {% else %}
                                when
                                    coe_competition_result.individual_result.{{ column_info.category }} [
                                        '{{ column_info.column }}'
                                    ]
                                    is not null
                                then
                                    string(
                                        coe_competition_result.individual_result.{{ column_info.category }} [
                                            '{{ column_info.column }}'
                                        ]
                                    )
                            {%- endif -%}
                        {%- endif -%}
                    {% endfor %}
                    else null
                end as {{ columns_dict.alias + "_detail" }}
                {%- if not loop.last %},{% endif -%}
            {% endfor %},
        from flatten_table
    )

select *
from get_columns
