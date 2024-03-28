with

not_aggregated_table as (
    select *, from {{ ref('base_coe__competition_results__get_columns') }}
),

aggregated_table as (
    select
        {# *, #}
        offset,
        program_url,
        id,
        cast(year as int) as year,
        individual_url,
            {# is_cws
        rep_org_flg
        is_size_30kg_boxes
        weight_kg_lbs_flg #}
            -- rank
        cast(regexp_extract(rank_table, "[0-9]+") as int) as rank_no,
        cast(replace(score_table, ",", ".") as numeric) as score,
        -- score
        regexp_extract(lower(rank_table), "[^0-9]+") as rank_cd,
        -- farm name
        regexp_replace(farm_cws_table, r"[–]", "") as farm_cws_table,
        regexp_replace(farm_name_detail, r"–", "-") as farm_name_detail,
        -- descriptions
    {# Aroma_Flavor #}
    from not_aggregated_table
)

select *,
from aggregated_table
