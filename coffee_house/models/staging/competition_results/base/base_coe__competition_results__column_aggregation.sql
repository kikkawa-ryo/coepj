with

not_aggregated_table as (
    select * from {{ ref('base_coe__competition_results__get_columns') }}
)

, aggregated_table as (
    select
        {# *, #}
        offset,
        program_url,
        id,
        CAST(year as INT) as year,
        individual_url,
        {# is_cws
        rep_org_flg
        is_size_30kg_boxes
        weight_kg_lbs_flg #}
        -- rank
        CAST(REGEXP_EXTRACT(rank_table, "[0-9]+") as INT) as rank_no,
        REGEXP_EXTRACT(LOWER(rank_table), "[^0-9]+") as rank_cd,
        -- score
        CAST(REPLACE(score_table, ",", ".") as NUMERIC)	as score,
        -- farm name
        REGEXP_REPLACE(farm_cws_table, r'[–]', '') as farm_cws_table,
        REGEXP_REPLACE(Farm_Name_detail, r'–', '-') as Farm_Name_detail
        -- descriptions
        {# Aroma_Flavor #}
    from
        not_aggregated_table
)

select * from aggregated_table