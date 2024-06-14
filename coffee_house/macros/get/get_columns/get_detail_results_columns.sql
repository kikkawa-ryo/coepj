{% macro get_detail_results_columns() %}
    {{ return(
        {"detail":
            [ {"alias": "Acidity",
            "previous": ["Acidity"],
            "renewal": [{"category": "lot_information", "column": "Acidity"}]
            }
            , {"alias": "Altitude",
            "previous": ["Altitude"],
            "renewal": [{"category": "farm_information", "column": "Altitude"}]
            }
            , {"alias": "Aroma_Flavor",
            "previous": ["Aroma_Flavor"],
            "renewal": [{"category": "lot_information", "column": "Aroma_Flavor"}]
            }
            , {"alias": "Auction",
            "previous": ["Auction"],
            "renewal": []
            }
            , {"alias": "Awards",
            "previous": [],
            "renewal": [{"category": "score", "column": "Awards"}]
            }
            , {"alias": "Auction_Lot_Size__kg",
            "previous": ["Auction_Lot_Size__kg_"],
            "renewal": []

            }
            , {"alias": "Auction_Lot_Size__lbs",
            "previous": ["Auction_Lot_Size__lbs__"],
            "renewal": []
            }
            , {"alias": "Business_Address",
            "previous": ["Business_Address"],
            "renewal": []
            }
            , {"alias": "Business_Phone_Number",
            "previous": ["Business_Phone_Number"],
            "renewal": []
            }
            , {"alias": "Business_Website_Address",
            "previous": ["Business_Website_Address"],
            "renewal": []
            }
            , {"alias": "Certifications",
            "previous": ["Certifications"],
            "renewal": []
            }
            , {"alias": "City",
            "previous": ["City"],
            "renewal": []
            }
            , {"alias": "Coffee_Characteristics",
            "previous": ["Coffee_Characteristics"],
            "renewal": []
            }
            , {"alias": "Coffee_Growing_Area",
            "previous": ["Coffee_Growing_Area"],
            "renewal": []
            }
            , {"alias": "Country",
            "previous": ["Country"],
            "renewal": []
            }
            , {"alias": "Farm_Name",
            "previous": ["Farm_Name"],
            "renewal": [{"category": "farm_information", "column": "Farm_Name"}]
            }
            , {"alias": "Farm_Size",
            "previous": ["Farm_Size"],
            "renewal": [{"category": "farm_information", "column": "Farm_Size"}]
            }
            , {"alias": "Farmer_Rep",
            "previous": ["Farmer_Rep_"],
            "renewal": [{"category": "farm_information", "column": "Farmer"}]
            }
            , {"alias": "High_bid",
            "previous": ["High_bid"],
            "renewal": []
            }
            , {"alias": "High_bidders",
            "previous": ["High_bidders"],
            "renewal": []
            }
            , {"alias": "Kilos",
            "previous": ["Kilos"],
            "renewal": []
            }
            , {"alias": "Month",
            "previous": ["Month"],
            "renewal": []
            }
            , {"alias": "Other",
            "previous": ["Other"],
            "renewal": []
            }
            , {"alias": "Overall",
            "previous": ["Overall"],
            "renewal": [{"category": "lot_information", "column": "Overall"}]
            }
            , {"alias": "Processing_System",
            "previous": ["Processing_system"],
            "renewal": [{"category": "lot_information", "column": "Processing_System"}]
            }
            , {"alias": "Program",
            "previous": ["Program"],
            "renewal": []
            }
            , {"alias": "Rank",
            "previous": ["Rank"],
            "renewal": [{"category": "score", "column": "Rank"}]
            }
            , {"alias": "Region",
            "previous": ["Region"],
            "renewal": []
            }
            , {"alias": "Score",
            "previous": [],
            "renewal": [{"category": "score", "column": "Score"}]
            }
            , {"alias": "Size__30kg_boxes",
            "previous": ["Size__30kg_boxes_"],
            "renewal": []
            }
            , {"alias": "Total_value",
            "previous": ["Total_value"],
            "renewal": []
            }
            , {"alias": "Variety",
            "previous": ["Variety_"],
            "renewal": [{"category": "lot_information", "column": "Variety"}]
            }
            , {"alias": "Year",
            "previous": ["Year"],
            "renewal": [{"category": "lot_information", "column": "Year"}]
            }
            ]
        }
        )
    }}
{% endmacro %}
