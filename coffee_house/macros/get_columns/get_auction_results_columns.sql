{% macro get_auction_results_columns() %}
    {{ return(
        {"table": 
            [ {"alias": "lot_number", "columns": ["LOT__", "Lot_Number", "Lot__", "RANK", "Rank"]}
            , {"alias": "score", "columns": ["SCORE", "Score"]}
            , {"alias": "farm_cws", "columns": ["FARM", "FARM_CWS", "Farm", "Farm_Name", "Nome", "WINNING_FARM___CWS", "Winning_Farm___CWS"]}
            , {"alias": "farmer", "columns": ["Farmer", "Farmer_Name"]}
            , {"alias": "total_value", "columns": ["TOTAL_VALUE", "Total_Value", "Total_Value____", "Total_value"]}
            , {"alias": "high_bid", "columns": ["Bid", "Bid____lb_", "HIGH_BID", "High_Bid"]}
            , {"alias": "commission", "columns": ["Comissions", "Commission"]}
            , {"alias": "lot_size", "columns": ["Boxes", "LOT_SIZE", "Lot_Size", "Quantity"]}
            , {"alias": "weight_lbs", "columns": ["Weight", "Weight_Lbs_", "Weight__Lbs_", "Weight___Lbs", "Weight___lbs", "Weight__lbs_", "Weight__lbs__", "Pounds"]}
            , {"alias": "high_bidder_s", "columns": ["Company_Name", "HIGH_BIDDER_S_", "High_Bidder_s_", "High_bidder", "Winner"]}
            , {"alias": "buyers_location", "columns": ["Buyer_s_Location", "Buyer_s_location"]}
            ],
        }
        )
    }}
{% endmacro %}