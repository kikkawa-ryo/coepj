{% macro get_cup_of_excellence_columns() %}
    {{ return(
        {
        "common": [
            {"column": "offset", "target": [1,2,3]},
            {"column": "country", "target": [1,2,3]},
            {"column": "year", "target": [1,2,3]},
            {"column": "program", "target": [1,2,3]},
            {"column": "award_category", "target": [1,2,3]},

            {"column": "rank", "target": [2,1,3]},
            {"column": "rank_no", "target": [2,1,3]},
            {"column": "rank_cd", "target": [2,1,3]},
            {"column": "score", "target": [1,2]},

            {"column": "is_cws", "target": [1]},
            {"column": "farmer_type", "target": [1]},

            {"column": "variety", "target": [1]},
            {"column": "process", "target": [1]},
            {"column": "region", "target": [1]},
            {"column": "woreda", "target": [1]},
            {"column": "zone", "target": [1]},

            {"column": "commission", "target": [2,3]},
            {"column": "high_bid", "target": [2,3]},
            {"column": "total_value", "target": [2,3]},

            {"column": "buyer_location", "target": [2]},

            {"column": "size_type", "target": [1]},
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
