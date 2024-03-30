with

base_coe__auction_results as (select *, from {{ ref('base_coe__auction_results__json_to_table') }}),
base_nw__auction_results as (select *, from {{ ref('base_nw__auction_results__json_to_table') }}),

auciton_results as (
    select * from base_coe__auction_results
    union all
    select * from base_nw__auction_results
),

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
        case
            when weight_unit = "kg" then PARSE_NUMERIC(regexp_replace(weight, r"lbs", "")) * 2.20462
            else PARSE_NUMERIC(regexp_replace(weight, r"lbs", ""))
        end as weight_lb,
        case
            when weight_unit = "lb" then PARSE_NUMERIC(regexp_replace(weight, r"lbs", "")) * 0.453592
            else PARSE_NUMERIC(regexp_replace(weight, r"lbs", ""))
        end as weight_kg,
        PARSE_NUMERIC(regexp_replace(if(total_value = "–", null, total_value), r"\$\.?|\s+", "")) as total_value,
        PARSE_NUMERIC(regexp_replace(high_bid, r"\$|\s+|/lb", "")) as high_bid,
        PARSE_NUMERIC(regexp_replace(commission, r"\$|\s+", "")) as commission,
        high_bidder,
        buyer_location,
        PARSE_NUMERIC(score) as score,
        url,
        individual_result,
     from auciton_results
)

select *,
from final