{% macro get_competition_results_columns() %}
    {{ return(
        {"table": 
            [ {"alias": "rank", "columns": ["RANK", "Rank"]}
            , {"alias": "score", "columns": ["SCORE", "Score"]}
            , {"alias": "farm_cws", "columns": ["FARM", "Farm", "Farm_Name", "FARM_CWS", "FARM___CWS", "Farm___CWS"]}
            , {"alias": "farmer_rep_org", "columns": ["FARMER", "Farmer", "FARMER___ORGANIZATION", "FARMER___REPRESENTATIVE", "Farmer___Representative", "PRODUCER", "Producer", "OWNER"]}
            , {"alias": "variety", "columns": ["VARIETY", "Variety"]}
            , {"alias": "process", "columns": ["PROCESS", "PROCESSING", "Process", "Processing"]}
            , {"alias": "region", "columns": ["REGION", "Region"]}
            , {"alias": "woreda", "columns": ["WOREDA", "Woreda"]}
            , {"alias": "zone", "columns": ["ZONE", "Zone"]}
            , {"alias": "lot_no", "columns": ["LOT_NO_"]}
            , {"alias": "size", "columns": ["SIZE", "Size", "SIZE__30KG_BOXES_", "Size__30kg_Boxes_"]}
            , {"alias": "weight_kg", "columns": ["WEIGHT__KG_", "WEIGHT__kg_", "Weight__kg_"]}
            , {"alias": "weight_lbs", "columns": ["Weight_Lbs_", "Weight___lbs"]}
            ],
        "detail":
            [ {"alias": "Acidity", "previous": ["Acidity"], "renewal": [{"category": "lot_information", "column": "Acidity"}]}
            , {"alias": "Altitude", "previous": ["Altitude"], "renewal": [{"category": "farm_information", "column": "Altitude"}]}
            , {"alias": "Aroma_Flavor", "previous": ["Aroma_Flavor"], "renewal": [{"category": "lot_information", "column": "Aroma / Flavor"}]}
            , {"alias": "Auction", "previous": ["Auction"], "renewal": []}
            , {"alias": "Awards", "previous": [], "renewal": [{"category": "score", "column": "Awards"}]}
            , {"alias": "Auction_Lot_Size__kg", "previous": ["Auction_Lot_Size__kg_"], "renewal": []}
            , {"alias": "Auction_Lot_Size__lbs", "previous": ["Auction_Lot_Size__lbs__"], "renewal": []}
            , {"alias": "Business_Address", "previous": ["Business_Address"], "renewal": []}
            , {"alias": "Business_Phone_Number", "previous": ["Business_Phone_Number"], "renewal": []}
            , {"alias": "Business_Website_Address", "previous": ["Business_Website_Address"], "renewal": []}
            , {"alias": "Certifications", "previous": ["Certifications"], "renewal": []}
            , {"alias": "City", "previous": ["City"], "renewal": []}
            , {"alias": "Coffee_Characteristics", "previous": ["Coffee_Characteristics"], "renewal": []}
            , {"alias": "Coffee_Growing_Area", "previous": ["Coffee_Growing_Area"], "renewal": []}
            , {"alias": "Country", "previous": ["Country"], "renewal": []}
            , {"alias": "Farm_Name", "previous": ["Farm_Name"], "renewal": [{"category": "farm_information", "column": "Farm Name"}]}
            , {"alias": "Farm_Size", "previous": ["Farm_Size"], "renewal": [{"category": "farm_information", "column": "Farm Size"}]}
            , {"alias": "Farmer_Rep", "previous": ["Farmer_Rep_"], "renewal": [{"category": "farm_information", "column": "Farmer"}]}
            , {"alias": "High_bid", "previous": ["High_bid"], "renewal": []}
            , {"alias": "High_bidders", "previous": ["High_bidders"], "renewal": []}
            , {"alias": "Kilos", "previous": ["Kilos"], "renewal": []}
            , {"alias": "Month", "previous": ["Month"], "renewal": []}
            , {"alias": "Other", "previous": ["Other"], "renewal": []}
            , {"alias": "Overall", "previous": ["Overall"], "renewal": [{"category": "lot_information", "column": "Overall"}]}
            , {"alias": "Processing_System", "previous": ["Processing_system"], "renewal": [{"category": "lot_information", "column": "Processing System"}]}
            , {"alias": "Program", "previous": ["Program"], "renewal": []}
            , {"alias": "Rank", "previous": ["Rank"], "renewal": [{"category": "score", "column": "Rank"}]}
            , {"alias": "Region", "previous": ["Region"], "renewal": []}
            , {"alias": "Score", "previous": [], "renewal": [{"category": "score", "column": "Score"}]}
            , {"alias": "Size__30kg_boxes", "previous": ["Size__30kg_boxes_"], "renewal": []}
            , {"alias": "Total_value", "previous": ["Total_value"], "renewal": []}
            , {"alias": "Variety", "previous": ["Variety_"], "renewal": [{"category": "lot_information", "column": "Variety"}]}
            , {"alias": "Year", "previous": ["Year"], "renewal": [{"category": "lot_information", "column": "Year"}]}
            , {"alias": "images", "previous": ["images"], "renewal": [{"category": "gallery", "column": ""}]}
            , {"alias": "location", "previous": [], "renewal": [{"category": "location", "column": ""}]}
            , {"alias": "similar_farm", "previous": [], "renewal": [{"category": "similar_farm", "column": ""}]}
            ],
        "pair": 
            [ {"table": "rank", "detail": ""}
            , {"table": "score", "detail": ""}
            , {"table": "farm_cws", "detail": ""}
            , {"table": "farmer_rep_org", "detail": ""}
            , {"table": "variety", "detail": ""}
            , {"table": "process", "detail": ""}
            , {"table": "region", "detail": ""}
            , {"table": "woreda", "detail": ""}
            , {"table": "zone", "detail": ""}
            , {"table": "lot_no", "detail": ""}
            , {"table": "size", "detail": ""}
            , {"table": "weight_kg", "detail": ""}
            , {"table": "weight_lbs", "detail": ""}
            ],
        }
        )
    }}
{% endmacro %}
