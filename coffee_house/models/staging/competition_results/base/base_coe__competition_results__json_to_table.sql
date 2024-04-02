with

flatten_table as (
    select *, from {{ ref('base_coe__competition_results__flatten') }}
),

get_columns as (
    select
        id,
        offset,
        country,
        year,
        program,
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
            when coe_competition_result.FARM___CWS is not null
                then true
            when coe_competition_result.Farm_Cws is not null
                then true
            when coe_competition_result.Farm___CWS is not null
                then true
            else false
        end as is_cws,
        case
            when coe_competition_result.Farmer_Organization is not null
                then "organization"
            when coe_competition_result.Farmer_Representative is not null
                then "representative"
            when coe_competition_result.Farmer___Representative is not null
                then "representative"
            when coe_competition_result.Owner is not null
                then "owner"
            when coe_competition_result.PRODUCER is not null
                then "producer"
            when coe_competition_result.Producer is not null
                then "producer"
            else null
        end as farmer_type,
        case
            when coe_competition_result.Size_30Kg_Boxes_ is not null
                then "30kg"
            else null
        end as size_type,
        case
            when coe_competition_result.Weight_Kg_ is not null
                then "kg"
            when coe_competition_result.Weight_Lbs is not null
                then "lb"
            when coe_competition_result.Weight_Lbs_ is not null
                then "lb"
            else null
        end as weight_unit,
    from flatten_table
)

select *,
from get_columns
