{{ config(
    materialized="table"
) }}

with

flatten_table as (select *, from {{ ref('base_coe__jury__flatten') }}),

normal_table as (
    select
        program_key,
        program_id,
        offset,
        country,
        year,
        judge_stage,
        {%- set columns_info = get_jury_columns() %}
        {%- for columns_dict in columns_info %}
            case
                {%- for column in columns_dict.columns %}
                    when jury.{{ column }} is not null
                        then
                            json_extract_scalar(
                                jury, "{{ '$.'~column }}"
                            )
                {%- endfor %}
                {%- if columns_dict.alias == "jury_name" %}
                    when
                        jury.first_name is not null
                        or jury.last_name is not null
                        then
                            concat(
                                json_extract_scalar(
                                    jury, "$.First_Name"
                                ),
                                " ",
                                json_extract_scalar(
                                    jury, "$.Last_Name"
                                )
                            )
                {% endif %}
                else null
            end as {{ columns_dict.alias }}{% if not loop.last %},{% endif %}
        {%- endfor -%},
        json_extract_scalar(jury, "$.Country") as jury_country,
        json_extract_scalar(jury, "$.Province") as jury_province,
        json_extract_scalar(jury, "$.Role") as jury_role,
        json_extract_scalar(jury, "$.group") as jury_group,
        json_extract_scalar(jury, "$.span") as span,
        "-" as assigned_stage,
    from
        flatten_table
    where
        not (
            program_id = "guatemala-2020"
            and judge_stage = "national"
        )
),

fixed_table as (
    select
        program_key,
        program_id,
        offset,
        country,
        year,
        judge_stage,
        json_extract_scalar(jury, "$.Pre_Selection") as jury_name,
        json_extract_scalar(jury, "$.organization") as jury_organization,
        json_extract_scalar(jury, "$.Country") as jury_country,
        json_extract_scalar(jury, "$.Province") as jury_province,
        json_extract_scalar(jury, "$.Role") as jury_role,
        json_extract_scalar(jury, "$.group") as jury_group,
        json_extract_scalar(jury, "$.span") as span,
        concat(
            "Pre_Selection", ",",
            if(
                json_extract_scalar(jury, "$.National_Week") = "–",
                "-",
                "National_Week"
            ),
            ",",
            if(
                json_extract_scalar(jury, "$.International_Week") = "–",
                "-",
                "International_Week"
            )
        ) as assigned_stage,
    from (
        select
            * except (jury),
            parse_json(
                regexp_replace(to_json_string(jury), r"\"\"", '"organization"')
            ) as jury,
        from
            flatten_table
        where
            (
                program_id = "guatemala-2020"
                and judge_stage = "national"
                and offset != 0
            )
    )
),

get_columns as (
    select *, from normal_table
    union all
    select *, from fixed_table
)


select *,
from get_columns
