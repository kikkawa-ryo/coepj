{% macro get_commissions_columns() %}
    {{ return(
        [ {"alias": "lot_number", "columns": ["Lot_", "Lot_Number", "Rank"]}
        , {"alias": "farm_cws", "columns": ["Farm", "Farm_Cws", "Winning_Farm_Cws"]}
        , {"alias": "farmer", "columns": ["Farmer"]}
        , {"alias": "lot_size", "columns": ["Boxes"]}
        , {"alias": "weight", "columns": ["Pounds"]}
        , {"alias": "total_value", "columns": ["Total_Value"]}
        , {"alias": "high_bid", "columns": ["Bid_Lb_", "High_Bid", "Highbid"]}
        , {"alias": "commission", "columns": ["Auction_Commission", "Comissions", "Commission", "Commissions", "Total_Comission", "Total_Commission"]}
        , {"alias": "high_bidder", "columns": ["Company_Name", "High_Bidder_Company_Name"]}
        ]
        )
    }}
{% endmacro %}
