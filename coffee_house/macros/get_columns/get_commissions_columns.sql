{% macro get_commissions_columns() %}
    {{ return(
        {"table": 
            [ {"alias": "lot_number", "columns": ["LOT__", "Lot_Number", "Lot__", "Lot_number", "RANK", "Rank"]}
            , {"alias": "farm_cws_farmer", "columns": ["FARM_CWS", "Farm", "WINNING_FARM___CWS", "Winning_Farm___CWS", "Farmer", "FARMER"]}
            , {"alias": "total_value", "columns": ["TOTAL_VALUE", "Total_Value", "Total_value"]}
            , {"alias": "high_bid", "columns": ["Bid____lb_", "HighBid", "High_Bid"]}
            , {"alias": "commission", "columns": ["AUCTION_COMMISSION", "Auction_Commission", "Comissions", "Commission", "Commissions", "TOTAL_COMISSION", "Total_Commission"]}
            , {"alias": "lot_size", "columns": ["Boxes"]}
            , {"alias": "weight_lbs", "columns": ["Pounds"]}
            , {"alias": "high_bidder_s", "columns": ["Company_Name", "High_Bidder_Company_Name"]}
            ],
        }
        )
    }}
{% endmacro %}
