with

base__commissions as (
    select *, from {{ ref('base_coe__commissions__json_to_table') }}
),

commissions_processed as (
    select
        offset,
        country,
        year,
        program,
        award_category,
        NORMALIZE_AND_CASEFOLD(farm_cws, NFKC) as farm_cws,
        NORMALIZE_AND_CASEFOLD(farmer, NFKC) as farmer,
        lot_size,
        NORMALIZE_AND_CASEFOLD(high_bidder, NFKC) as high_bidder,
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
            lower(regexp_replace(lot_number, r'T|\s', ''))
        ) as id_rank,
        lower(regexp_replace(lot_number, r'T|\s', '')) as rank,
        regexp_substr(lower(regexp_replace(lot_number, r'T|\s', '')), r'\d+')
            as rank_no,
        regexp_substr(lower(regexp_replace(lot_number, r'T|\s', '')), r'\D')
            as rank_cd,
        regexp_replace(weight, r'lbs', '') as weight,
        if(
            regexp_contains(total_value, r'^–?$'),
            null,
            regexp_replace(total_value, r'\$\.?|\s+|/lb', '')
        ) as total_value,
        if(
            regexp_contains(high_bid, r'^–?$'),
            null,
            regexp_replace(high_bid, r'\$\.?|\s+|/lb', '')
        ) as high_bid,
        if(
            regexp_contains(commission, r'^–?$'),
            null,
            regexp_replace(commission, r'\$\.?|\s+|/lb', '')
        ) as commission,
        coalesce(regexp_contains(lot_size, r'\(.+\)'), false) as have_partial,
    from base__commissions
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
        cast(lot_size as INT64) as lot_size,
        high_bidder,
        span,
        url,
        individual_result,
        case
            when weight_unit = 'kg' then parse_numeric(weight) * 2.20462
            else parse_numeric(weight)
        end as weight_lb,
        case
            when weight_unit = 'lb' then parse_numeric(weight) * 0.453592
            else parse_numeric(weight)
        end as weight_kg,
        parse_numeric(total_value) as total_value,
        parse_numeric(high_bid) as high_bid,
        parse_numeric(commission) as commission,
    from commissions_processed
)

select *,
from final
