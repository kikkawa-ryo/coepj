{% macro get_cup_of_excellence_columns() %}
    {{ return(
        {
        "common": [
            {"column": "program_key", "target_and_priority": [1,2,3]},
            {"column": "offset", "target_and_priority": [1,2,3]},
            {"column": "country", "target_and_priority": [1,2,3]},
            {"column": "year", "target_and_priority": [1,2,3]},
            {"column": "award_category", "target_and_priority": [1,2,3]},

            {"column": "rank", "target_and_priority": [2,1,3]},
            {"column": "rank_no", "target_and_priority": [2,1,3]},
            {"column": "rank_cd", "target_and_priority": [2,1,3]},
            {"column": "score", "target_and_priority": [1,2]},

            {"column": "is_cws", "target_and_priority": [1]},
            {"column": "farmer_type", "target_and_priority": [1]},

            {"column": "variety", "target_and_priority": [1]},
            {"column": "process", "target_and_priority": [1]},
            {"column": "region", "target_and_priority": [1]},
            {"column": "woreda", "target_and_priority": [1]},
            {"column": "zone", "target_and_priority": [1]},

            {"column": "commission", "target_and_priority": [2,3]},
            {"column": "high_bid", "target_and_priority": [2,3]},
            {"column": "total_value", "target_and_priority": [2,3]},

            {"column": "buyer_location", "target_and_priority": [2]},

            {"column": "size_type", "target_and_priority": [1]},
        ]
        ,
        "competition":
            [ "farm_cws", "farmer", "have_partial", "span"]
        ,
        "auction":
            [ "farm_cws", "farmer", "high_bidder", "have_partial", "span"]
        ,
        "commissions":
            [ "farm_cws", "farmer", "high_bidder", "span"]
        }
        )
    }}
{% endmacro %}
