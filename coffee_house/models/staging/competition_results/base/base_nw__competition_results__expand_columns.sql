with

flatten_table as (
    select *, from {{ ref('base_nw__competition_results__flatten') }}
),

get_columns as (
    select
        offset,
        country,
        year,
        program_key,
        award_category,
        {%- set columns_info = get_competition_results_columns() -%}
        {% for columns_dict in columns_info.nw %}
            case
                {%- for column in columns_dict.columns %}
                    when nw_competition_result.{{ column }} is not null
                        then
                            json_extract_scalar(
                                nw_competition_result, "{{ '$.'~column }}"
                            )
                {%- endfor %}
                else null
            end as {{ columns_dict.alias }}
            {%- if not loop.last %},{% endif -%}
        {% endfor %},
        CASE
            WHEN nw_competition_result.Variety IS NOT NULL
                THEN json_extract_scalar(nw_competition_result, "$.Variety")
            WHEN nw_competition_result.Variety_Processing IS NOT NULL
                THEN (select trim(variety) from unnest(split(regexp_replace(json_extract_scalar(nw_competition_result, "$.Variety_Processing"),"/",","), ",")) variety where variety != (select element from unnest(split(regexp_replace(json_extract_scalar(nw_competition_result, "$.Variety_Processing"),"/",","), ",")) element where regexp_contains(element, "(?i)(washed|natural|honey|anaeróbic|natrual)") order by length(element) asc limit 1))
            WHEN nw_competition_result.Process_Variety IS NOT NULL
                THEN (select trim(variety) from unnest(split(regexp_replace(json_extract_scalar(nw_competition_result, "$.Process_Variety"),"/",","), ",")) variety where variety != (select element from unnest(split(regexp_replace(json_extract_scalar(nw_competition_result, "$.Process_Variety"),"/",","), ",")) element where regexp_contains(element, "(?i)(washed|natural|honey|anaeróbic|natrual)") order by length(element) asc limit 1))
            ELSE null
        END AS variety,
        CASE
            WHEN nw_competition_result.Process IS NOT NULL
                THEN json_extract_scalar(nw_competition_result, "$.Process")
            WHEN nw_competition_result.Processing IS NOT NULL
                THEN json_extract_scalar(nw_competition_result, "$.Processing")
            WHEN nw_competition_result.Variety_Processing IS NOT NULL
                THEN (select trim(process) from unnest(split(regexp_replace(json_extract_scalar(nw_competition_result, "$.Variety_Processing"),"/",","), ",")) process where regexp_contains(process, "(?i)(washed|natural|honey|anaeróbic|natrual)") order by length(process) asc limit 1)
            WHEN nw_competition_result.Process_Variety IS NOT NULL
                THEN (select trim(process) from unnest(split(regexp_replace(json_extract_scalar(nw_competition_result, "$.Process_Variety"),"/",","), ",")) process where regexp_contains(process, "(?i)(washed|natural|honey|anaeróbic|natrual)") order by length(process) asc limit 1)
            ELSE null
        END AS process,
        json_extract_scalar(nw_competition_result, "$.span") as span,
        json_extract_scalar(nw_competition_result, "$.url") as url,
        nw_competition_result.individual_result,
        -- カラム名の情報をフラグ化して引き継ぐ
        case
            when nw_competition_result.Coffee_Washing_Station_Name is not null
                then true
            when nw_competition_result.Farm_Cws is not null
                then true
            else false
        end as is_cws,
        case
            when nw_competition_result.Coffee_Washing_Station_Owner is not null
                then "owner"
            when nw_competition_result.Farmer_Organization is not null
                then "organization"
            when nw_competition_result.Farmer_Representative is not null
                then "representative"
            else null
        end as farmer_type,
        case
            when nw_competition_result.Size_69Kg_Bags_ is not null
                then "69kg"
            else null
        end as size_type,
        case
            when nw_competition_result.Weight_Kg_ is not null
                then "kg"
            when nw_competition_result.Weight_Lbs is not null
                then "lb"
            when nw_competition_result.Weight_Lbs_ is not null
                then "lb"
            when nw_competition_result.Size_Lbs_ is not null
                then "lb"
            else null
        end as weight_unit,
    from flatten_table
),

final as (
    select
    *
    from
    get_columns
)

select *,
from get_columns
