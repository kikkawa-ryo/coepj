{{ config(
    materialized="table"
) }}
with

base_coe__competition_results as (select *, from {{ ref('base_coe__competition_results__json_to_table') }}),
base_nw__competition_results as (select *, from {{ ref('base_nw__competition_results__json_to_table') }}),

competition_results as (
    select * from base_coe__competition_results
    union all
    select * from base_nw__competition_results
),

competition_results_processed as (
    select
        id,
        offset,
        country,
        year,
        program,
        award_category,
        regexp_substr(lower(regexp_replace(rank, r"T|\s", "")), r"\d") as rank_no,
        regexp_substr(lower(regexp_replace(rank, r"T|\s", "")), r"\D") as rank_cd,
        score,
        farm_cws,
        farmer,
        variety,
        process,
        region,
        woreda,
        zone,
        trim(regexp_replace(lot_size, r"\(.+\)", "")) as lot_size,
        CASE
            WHEN REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(2)] IS NOT NULL THEN CONCAT(REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(0)], REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(1)], ".",REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(2)])
            WHEN REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(1)] IS NOT NULL THEN CONCAT(REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(0)], ".", REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(1)])
            WHEN REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(0)] IS NOT NULL THEN REGEXP_EXTRACT_ALL(regexp_replace(weight, r"lbs", ""), r'\d+')[SAFE_OFFSET(0)]
            ELSE null
        END AS weight,
        is_cws,
        farmer_type,
        size_type,
        weight_unit,
        CASE
            WHEN regexp_contains(lot_size, r"\D") THEN true
            ELSE false
        END AS have_partial,
        span,
        url,
        individual_result,
     from competition_results
),

final as (
    select
    id,
        offset,
        country,
        year,
        program,
        award_category,
        CAST(rank_no AS INT64) as rank_no,
        rank_cd,
        PARSE_NUMERIC(score) as score,
        farm_cws,
        farmer,
        variety,
        process,
        region,
        woreda,
        zone,
        CAST(lot_size AS INT64) as lot_size,
        case
            when weight_unit = "kg" then PARSE_NUMERIC(weight) * 2.20462
            else PARSE_NUMERIC(weight)
        end as weight_lb,
        case
            when weight_unit = "lb" then PARSE_NUMERIC(weight) * 0.453592
            else PARSE_NUMERIC(weight)
        end as weight_kg,
        is_cws,
        farmer_type,
        size_type,
        weight_unit,
        have_partial,
        span,
        url,
        individual_result,
     from competition_results_processed
)

select *,
from final