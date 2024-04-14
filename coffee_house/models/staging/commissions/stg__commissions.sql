with

base__commissions as (
    select *, from {{ ref('base_coe__commissions__json_to_table') }}
),

final as (
    select
        offset,
        country,
        year,
        program,
        award_category,
        farm_cws,
        farmer,
        cast(lot_size as INT64) as lot_size,
        NORMALIZE_AND_CASEFOLD(high_bidder, NFKC) as high_bidder,
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
        regexp_substr(lower(regexp_replace(lot_number, r'T|\s', '')), r'\d')
            as rank_no,
        regexp_substr(lower(regexp_replace(lot_number, r'T|\s', '')), r'\D')
            as rank_cd,
        parse_numeric(regexp_replace(weight, r'lbs', '')) as weight_lb,
        parse_numeric(regexp_replace(weight, r'lbs', ''))
        * 0.453592 as weight_kg,
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
    from base__commissions
)

select *,
from final
