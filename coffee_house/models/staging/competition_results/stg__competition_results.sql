{{
    config(
        materialized = "table"
    )
}}
with

base_coe__competition_results as (
    select *, from {{ ref('base_coe__competition_results__json_to_table') }}
),

base_nw__competition_results as (
    select *, from {{ ref('base_nw__competition_results__json_to_table') }}
),

competition_results as (
    select *, from base_coe__competition_results
    union all
    select *, from base_nw__competition_results
),

competition_results_processed as (
    select
        offset,
        country,
        year,
        program,
        award_category,
        score,
        regexp_replace(NORMALIZE_AND_CASEFOLD(farm_cws, NFKC), r"{.+}|\(?\d{4}\)?", "") as farm_cws,
        regexp_replace(NORMALIZE_AND_CASEFOLD(farmer, NFKC), r"{.+}|\(?\d{4}\)?", "") as farmer,
        variety,
        process,
        region,
        woreda,
        zone,
        is_cws,
        farmer_type,
        size_type,
        weight_unit,
        span,
        url,
        individual_result,
        concat(program, '_', award_category, '_', offset) as id_offset,
        concat(
            program,
            '_',
            award_category,
            '_',
            lower(regexp_replace(rank, r'T|\s', ''))
        ) as id_rank,
        lower(regexp_replace(rank, r'T|\s', '')) as rank,
        regexp_substr(lower(regexp_replace(rank, r'T|\s', '')), r'\d+')
            as rank_no,
        regexp_substr(lower(regexp_replace(rank, r'T|\s', '')), r'\D')
            as rank_cd,
        trim(regexp_replace(lot_size, r'\(.+\)', '')) as lot_size,
        case
            when
                regexp_extract_all(regexp_replace(weight, r'lbs', ''), r'\d+')[
                    safe_offset(2)
                ] is not NULL
                then
                    concat(
                        regexp_extract_all(
                            regexp_replace(weight, r'lbs', ''), r'\d+'
                        )[safe_offset(0)],
                        regexp_extract_all(
                            regexp_replace(weight, r'lbs', ''), r'\d+'
                        )[safe_offset(1)],
                        '.',
                        regexp_extract_all(
                            regexp_replace(weight, r'lbs', ''), r'\d+'
                        )[safe_offset(2)]
                    )
            when
                regexp_extract_all(regexp_replace(weight, r'lbs', ''), r'\d+')[
                    safe_offset(1)
                ] is not NULL
                then
                    concat(
                        regexp_extract_all(
                            regexp_replace(weight, r'lbs', ''), r'\d+'
                        )[safe_offset(0)],
                        '.',
                        regexp_extract_all(
                            regexp_replace(weight, r'lbs', ''), r'\d+'
                        )[safe_offset(1)]
                    )
            when
                regexp_extract_all(regexp_replace(weight, r'lbs', ''), r'\d+')[
                    safe_offset(0)
                ] is not NULL
                then
                    regexp_extract_all(
                        regexp_replace(weight, r'lbs', ''), r'\d+'
                    )[safe_offset(0)]
        end as weight,
        coalesce (regexp_contains(lot_size, r'\(.+\)'), false) as have_partial,
    from competition_results
),

final as (
    select
        id_offset,
        id_rank,
        offset,
        country,
        year,
        program,
        award_category,
        rank,
        cast(rank_no as INT64) as rank_no,
        rank_cd,
        farm_cws,
        farmer,
        variety,
        process,
        region,
        woreda,
        zone,
        cast(lot_size as INT64) as lot_size,
        is_cws,
        farmer_type,
        size_type,
        have_partial,
        span,
        url,
        individual_result,
        parse_numeric(score) as score,
        case
            when weight_unit = 'lb' then parse_numeric(weight)
            else parse_numeric(weight) * 2.20462
        end as weight_lb,
        case
            when weight_unit = 'kg' then parse_numeric(weight)
            else parse_numeric(weight) * 0.453592
        end as weight_kg,
    from competition_results_processed
)

select *,
from final
