{% macro get_auction_results_columns() %}
    {{ return( 
        {
        "coe": 
            [ {"alias": "lot_number", "columns": ["Lot_", "Lot_Number", "Rank"]}
            , {"alias": "farm_cws", "columns": ["Farm", "Farm_Cws", "Farm_Name", "Nome", "Winning_Farm_Cws"]}
            , {"alias": "farmer", "columns": ["Farmer", "Farmer_Name"]}
            , {"alias": "lot_size", "columns": ["Boxes", "Lot_Size", "Quantity"]}
            , {"alias": "weight", "columns": ["Pounds", "Weight", "Weight_Lbs", "Weight_Lbs_", "Weight___lbs"]}
            , {"alias": "total_value", "columns": ["Total_Value", "Total_Value_"]}
            , {"alias": "high_bid", "columns": ["Bid", "Bid_Lb_", "Bid____lb_", "High_Bid"]}
            , {"alias": "commission", "columns": ["Comissions", "Commission"]}
            , {"alias": "high_bidder", "columns": ["Company_Name", "High_Bidder", "High_Bidder_S_", "Winner"]}
            , {"alias": "buyer_location", "columns": ["Buyer_S_Location", "Buyer_S_Location"]}
            , {"alias": "score", "columns": ["ANONYMOUS"]}
            ],
        "nw": 
            [ {"alias": "lot_number", "columns": ["ANONYMOUS"]}
            , {"alias": "farm_cws", "columns": ["FARM", "Farm", "Lot"]}
            , {"alias": "farmer", "columns": ["Farmer", "Farmer_Organization"]}
            , {"alias": "lot_size", "columns": ["Boxes", "Lot_Size", "Quantity"]}
            , {"alias": "weight", "columns": ["Weight_Kg_", "Weight_Lbs_", "Weight__Lbs_"]}
            , {"alias": "total_value", "columns": ["Total_Value"]}
            , {"alias": "high_bid", "columns": ["Bid_Lb_", "High_Bid", "_Lb"]}
            , {"alias": "commission", "columns": ["ANONYMOUS"]}
            , {"alias": "high_bidder", "columns": ["Company_Name", "High_Bidder_S_", "High_Bidder_s_", "Winner"]}
            , {"alias": "buyer_location", "columns": ["Bidder_S_Location"]}
            , {"alias": "score", "columns": ["Score"]}
            ]
        }
        )
    }}
{% endmacro %}
