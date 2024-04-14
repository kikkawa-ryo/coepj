{% macro get_cup_of_excellence_columns() %}
    {{ return(
        { "common":
            [ "country", "year", "program", "award_category"]
        ,
         "competition":
            [ "id_offset", "id_rank", "offset", "rank", "rank_no", "rank_cd", "score",
                "farm_cws", "farmer", "variety", "process", "region", "woreda", "zone", "lot_size", "weight_lb", "weight_kg",
                "is_cws", "farmer_type", "size_type", "have_partial", "span"]
        ,
         "auction":
            [ "id_offset", "id_rank", "offset", "rank", "rank_no", "rank_cd", "score",
                "farm_cws", "farmer", "lot_size", "weight_lb", "weight_kg", "total_value", "high_bid", "commission", "high_bidder", "buyer_location",
                "have_partial", "span"]
        ,
         "commissions":
            [ "id_offset", "id_rank", "offset", "rank", "rank_no", "rank_cd",
                "farm_cws", "farmer", "lot_size", "weight_lb", "weight_kg", "total_value", "high_bid", "commission", "high_bidder",
                "span"]
        }
        )
    }}
{% endmacro %}
