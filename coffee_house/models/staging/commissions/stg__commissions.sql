with

base__commissions as (select *, from {{ ref('base_coe__commissions__json_to_table') }}),

final as (
    select
    id,
        offset,
        country,
        year,
        program,
        award_category,
        regexp_substr(lower(regexp_replace(lot_number, r"T|\s", "")), r"\d") as rank_no,
        regexp_substr(lower(regexp_replace(lot_number, r"T|\s", "")), r"\D") as rank_cd,
        farm_cws,
        farmer,
        CAST(lot_size AS INT64) as lot_size,
        PARSE_NUMERIC(regexp_replace(weight, r"lbs", "")) as weight_lb,
        PARSE_NUMERIC(regexp_replace(weight, r"lbs", "")) * 0.453592 as weight_kg,
        PARSE_NUMERIC(regexp_replace(if(total_value = "–", null, total_value), r"\$\.?|\s+", "")) as total_value,
        PARSE_NUMERIC(regexp_replace(high_bid, r"\$|\s+|/lb", "")) as high_bid,
        PARSE_NUMERIC(regexp_replace(if(commission = "–", null, commission), r"\$|\s+", "")) as commission,
        high_bidder,
        span,
        url,
        individual_result,
     from base__commissions
)

select *,
from final