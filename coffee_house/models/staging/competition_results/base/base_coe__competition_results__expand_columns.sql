with

flatten_table as (
    select *, from {{ ref('base_coe__competition_results__flatten') }}
),

expanded_table as (
    select
        program_key,
        program_id,
        offset,
        country,
        year,
        award_category,
        {%- set columns_info = get_competition_results_columns() -%}
        {% for columns_dict in columns_info.coe %}
            case
                {%- for column in columns_dict.columns %}
                    when coe_competition_result.{{ column }} is not null
                        then
                            json_extract_scalar(
                                coe_competition_result, "{{ '$.'~column }}"
                            )
                {%- endfor %}
                else null
            end as {{ columns_dict.alias }}
            {%- if not loop.last %},{% endif -%}
        {% endfor %},
        json_extract_scalar(coe_competition_result, "$.span") as span,
        json_extract_scalar(coe_competition_result, "$.url") as url,
        coe_competition_result.individual_result,
        -- カラム名の情報をフラグ化して引き継ぐ
        case
            when coe_competition_result.farm___cws is not null
                then true
            when coe_competition_result.farm_cws is not null
                then true
            when coe_competition_result.farm___cws is not null
                then true
            else false
        end as is_cws,
        case
            when coe_competition_result.farmer_organization is not null
                then "organization"
            when coe_competition_result.farmer_representative is not null
                then "representative"
            when coe_competition_result.farmer___representative is not null
                then "representative"
            when coe_competition_result.owner is not null
                then "owner"
            when coe_competition_result.producer is not null
                then "producer"
            when coe_competition_result.producer is not null
                then "producer"
        end as farmer_type,
        case
            when coe_competition_result.size_30kg_boxes_ is not null
                then "30kg"
        end as size_type,
        case
            when coe_competition_result.weight_kg_ is not null
                then "kg"
            when coe_competition_result.weight_lbs is not null
                then "lb"
            when coe_competition_result.weight_lbs_ is not null
                then "lb"
        end as weight_unit,
    from flatten_table
)

select *,
from expanded_table
