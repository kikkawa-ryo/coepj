{% macro get_competition_results_columns() %}
    {{ return(
        {"coe": 
            [ {"alias": "rank", "columns": ["RANK", "Rank"]}
            , {"alias": "score", "columns": ["SCORE", "Score"]}
            , {"alias": "farm_cws", "columns": ["FARM___CWS", "Farm", "Farm_Cws", "Farm_Name", "Farm___CWS"]}
            , {"alias": "farmer", "columns": ["Farmer", "Farmer_Organization", "Farmer_Representative", "Farmer___Representative", "Owner", "PRODUCER", "Producer"]}
            , {"alias": "region", "columns": ["REGION", "Region"]}
            , {"alias": "woreda", "columns": ["Woreda"]}
            , {"alias": "zone", "columns": ["Zone"]}
            , {"alias": "lot_size", "columns": ["SIZE", "Size", "Size_30Kg_Boxes_"]}
            , {"alias": "weight", "columns": ["Weight_Kg_", "Weight_Lbs", "Weight_Lbs_"]}
            , {"alias": "variety", "columns": ["VARIETY", "Variety"]}
            , {"alias": "process", "columns": ["PROCESS", "Process", "Processing"]}
            ],
        "nw": 
            [ {"alias": "rank", "columns": ["Rank", "Lot_"]}
            , {"alias": "score", "columns": ["Score"]}
            , {"alias": "farm_cws", "columns": ["Coffee_Washing_Station_Name", "Farm", "Farm_Cws", "Farm_Name"]}
            , {"alias": "farmer", "columns": ["Coffee_Washing_Station_Owner", "Farmer", "Farmer_Organization", "Farmer_Representative"]}
            , {"alias": "region", "columns": ["Region"]}
            , {"alias": "woreda", "columns": ["Woreda"]}
            , {"alias": "zone", "columns": ["Zone"]}
            , {"alias": "lot_size", "columns": ["Size", "Size_69Kg_Bags_"]}
            , {"alias": "weight", "columns": ["Weight_Kg_", "Weight_Lbs", "Weight_Lbs_", "Size_Lbs_"]}
            ]
        }
        )
    }}
{% endmacro %}
