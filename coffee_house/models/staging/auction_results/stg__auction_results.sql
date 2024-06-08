{{
    config(
        materialized = "table",
        post_hook = 'delete from {{this}} where program_key in ("nicaragua-2002")'
    )
}}

with

base_coe__auction_results as (
    select *, from {{ ref('base_coe__auction_results__expand_columns') }}
),

base_nw__auction_results as (
    select *, from {{ ref('base_nw__auction_results__expand_columns') }}
),

auciton_results as (
    select *, from base_coe__auction_results
    union all
    select *, from base_nw__auction_results
),

auciton_results_processed as (
    select
        offset,
        country,
        year,
        program_key,
        award_category,
        score,
        regexp_replace(NORMALIZE_AND_CASEFOLD(farm_cws, NFKC), r"{.+}|\(?\d{4}\)?", "") as farm_cws,
        regexp_replace(NORMALIZE_AND_CASEFOLD(farmer, NFKC), r"{.+}|\(?\d{4}\)?", "") as farmer,
        lot_size,
        NORMALIZE_AND_CASEFOLD(high_bidder, NFKC) as high_bidder,
        NORMALIZE_AND_CASEFOLD(buyer_location, NFKC) as buyer_location,
        weight_unit,
        span,
        url,
        individual_result,
        concat(program_key, '_', award_category, '_', offset) as id_offset,
        concat(
            program_key,
            '_',
            award_category,
            '_',
            lower(regexp_replace(lot_number, r'T|\s', ''))
        ) as id_rank,
        lower(regexp_replace(lot_number, r'T|\s', '')) as rank,
        regexp_substr(lower(regexp_replace(lot_number, r'T|\s', '')), r'\d+')
            as rank_no,
        regexp_substr(lower(regexp_replace(lot_number, r'T|\s', '')), r'\D')
            as rank_cd,
        regexp_replace(weight, r'lbs', '') as weight,
        if(
            regexp_contains(total_value, r'^-?$'),
            null,
            regexp_replace(total_value, r'\$\.?|\s+|(/)?lb', '')
        ) as total_value,
        if(
            regexp_contains(high_bid, r'^-?$'),
            null,
            regexp_replace(high_bid, r'\$\.?|\s+|(/)?lb', '')
        ) as high_bid,
        if(
            regexp_contains(commission, r'^-?$'),
            null,
            regexp_replace(commission, r'\$\.?|\s+|(/)?lb', '')
        ) as commission,
        coalesce(regexp_contains(lot_size, r'\(.+\)'), false) as have_partial,
    from auciton_results
),

final as (
    select
        id_offset,
        id_rank,
        offset,
        country,
        year,
        program_key,
        award_category,
        rank,
        cast(rank_no as INT64) as rank_no,
        rank_cd,
        farm_cws,
        farmer,
        cast(lot_size as INT64) as lot_size,
        high_bidder,
        buyer_location,
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
        parse_numeric(total_value) as total_value,
        parse_numeric(high_bid) as high_bid,
        parse_numeric(commission) as commission,
    from auciton_results_processed
)

select *,
from final
