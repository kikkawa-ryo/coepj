with

source as (
    select * from {{ ref('stg_coe_results') }}
)

, coe_competition_results as (
    select
        url,
        case
            when contents.COE_Competition_Results is not null then contents.COE_Competition_Results
            when contents.Winning_Farms is not null then contents.Winning_Farms
            when contents.Winning_Farms_ is not null then contents.Winning_Farms_
            else null
        end as coe_competition_results_array
    from
        source
)

, get_json_value_and_make_flag as (
    -- table情報において名寄せとフラグ作成
    select
        coe_competition_results.url as program_url,
    -- rank
        case
            when coe_competition_result.RANK is not null then coe_competition_result.RANK
            when coe_competition_result.Rank is not null then coe_competition_result.Rank
            else null
        end as rank,
    -- score
        case
            when coe_competition_result.SCORE is not null then coe_competition_result.SCORE
            when coe_competition_result.Score is not null then coe_competition_result.Score
            else null
        end as score,  
    -- farm / farmer
        case
            when coe_competition_result.FARM is not null then coe_competition_result.FARM
            when coe_competition_result.Farm is not null then coe_competition_result.Farm
            when coe_competition_result.Farm_Name is not null then coe_competition_result.Farm_Name
            when coe_competition_result.FARM_CWS is not null then coe_competition_result.FARM_CWS
            when coe_competition_result.FARM___CWS is not null then coe_competition_result.FARM___CWS
            when coe_competition_result.Farm___CWS is not null then coe_competition_result.Farm___CWS
            else null
        end as farm_cws,
        case
            when coe_competition_result.FARM_CWS is not null then 1
            when coe_competition_result.FARM___CWS is not null then 1
            when coe_competition_result.Farm___CWS is not null then 1
            else 0
        end as cws_flg,
        case
            when coe_competition_result.FARMER is not null then coe_competition_result.FARMER
            when coe_competition_result.Farmer is not null then coe_competition_result.Farmer
            when coe_competition_result.FARMER___ORGANIZATION is not null then coe_competition_result.FARMER___ORGANIZATION
            when coe_competition_result.FARMER___REPRESENTATIVE is not null then coe_competition_result.FARMER___REPRESENTATIVE
            when coe_competition_result.Farmer___Representative is not null then coe_competition_result.Farmer___Representative
            when coe_competition_result.PRODUCER is not null then coe_competition_result.PRODUCER
            when coe_competition_result.Producer is not null then coe_competition_result.Producer
            when coe_competition_result.OWNER is not null then coe_competition_result.OWNER
            else null
        end as farmer_rep_org,
        case
            when coe_competition_result.FARMER___ORGANIZATION is not null then 1
            when coe_competition_result.FARMER___REPRESENTATIVE is not null then 1
            when coe_competition_result.Farmer___Representative is not null then 1
            else 0
        end as rep_org_flg,
    -- variety
        case
            when coe_competition_result.VARIETY is not null then coe_competition_result.VARIETY
            when coe_competition_result.Variety is not null then coe_competition_result.Variety
            else null
        end as variety,
    -- process
        case
            when coe_competition_result.PROCESS is not null then coe_competition_result.PROCESS
            when coe_competition_result.PROCESSING is not null then coe_competition_result.PROCESSING
            when coe_competition_result.Process is not null then coe_competition_result.Process
            when coe_competition_result.Processing is not null then coe_competition_result.Processing
            else null
        end as process,
    -- region
        case
            when coe_competition_result.REGION is not null then coe_competition_result.REGION
            when coe_competition_result.Region is not null then coe_competition_result.Region
            else null
        end as region,
    -- woreda
        case
            when coe_competition_result.WOREDA is not null then coe_competition_result.WOREDA
            when coe_competition_result.Woreda is not null then coe_competition_result.Woreda
            else null
        end as woreda,
    -- zone
        case
            when coe_competition_result.ZONE is not null then coe_competition_result.ZONE
            when coe_competition_result.Zone is not null then coe_competition_result.Zone
            else null
        end as zone,
    -- lot No.
        coe_competition_result.LOT_NO_ as lot_no,
    -- size
        case
            when coe_competition_result.SIZE is not null then coe_competition_result.SIZE
            when coe_competition_result.Size is not null then coe_competition_result.Size
            when coe_competition_result.SIZE__30KG_BOXES_ is not null then coe_competition_result.SIZE__30KG_BOXES_
            when coe_competition_result.Size__30kg_Boxes_ is not null then coe_competition_result.Size__30kg_Boxes_
            else null
        end as size,
        case
            when coe_competition_result.SIZE__30KG_BOXES_ is not null then 1
            when coe_competition_result.Size__30kg_Boxes_ is not null then 1
            else 0
        end as size_30kg_boxes_flg,
    -- weight
        case
            when coe_competition_result.WEIGHT__KG_ is not null then coe_competition_result.WEIGHT__KG_
            when coe_competition_result.WEIGHT__kg_ is not null then coe_competition_result.WEIGHT__kg_
            when coe_competition_result.Weight__kg_ is not null then coe_competition_result.Weight__kg_
            when coe_competition_result.Weight_Lbs_ is not null then coe_competition_result.Weight_Lbs_
            when coe_competition_result.Weight___lbs is not null then coe_competition_result.Weight___lbs
            else null
        end as weight,
        case
            when coe_competition_result.WEIGHT__KG_ is not null then 1
            when coe_competition_result.WEIGHT__kg_ is not null then 1
            when coe_competition_result.Weight__kg_ is not null then 1
            when coe_competition_result.Weight_Lbs_ is not null then 2
            when coe_competition_result.Weight___lbs is not null then 2
            else 0
        end as weight_kg_lbs_flg,
    -- 個別ページに関する情報をjson形式から展開
    -- individual result
        coe_competition_result.url                                               as individual_url,
        coe_competition_result.individual_result.description                     as individual_description,
        case
            when if(coe_competition_result.farm_information is not null, true, false) then "renewal"
            else "previous"
        end as site_flg,
    -- previous site
        coe_competition_result.individual_result.detail.Acidity                  as individual_attributes_acidity,
        coe_competition_result.individual_result.detail.Altitude                 as individual_altitude,
        coe_competition_result.individual_result.detail.Aroma_Flavor             as individual_attributes_aroma_flavor,
        coe_competition_result.individual_result.detail.Auction                  as individual_auction,
        coe_competition_result.individual_result.detail.Auction_Lot_Size__kg_    as individual_auction_lot_size_kg,
        coe_competition_result.individual_result.detail.Auction_Lot_Size__lbs__  as individual_auction_lot_size_lbs,
        coe_competition_result.individual_result.detail.Business_Address         as individual_business_address,
        coe_competition_result.individual_result.detail.Business_Phone_Number    as individual_business_phone_number,
        coe_competition_result.individual_result.detail.Business_Website_Address as individual_business_website_address,
        coe_competition_result.individual_result.detail.Certifications           as individual_certifications,
        coe_competition_result.individual_result.detail.City                     as individual_city,
        coe_competition_result.individual_result.detail.Coffee_Characteristics   as individual_attributes_coffee_characteristics,
        coe_competition_result.individual_result.detail.Coffee_Growing_Area      as individual_coffee_growing_area,
        coe_competition_result.individual_result.detail.Country                  as individual_country,
        coe_competition_result.individual_result.detail.Farm_Name                as individual_farm_name,
        coe_competition_result.individual_result.detail.Farm_Size                as individual_farm_size,
        coe_competition_result.individual_result.detail.Farmer_Rep_              as individual_farmer_rep,
        coe_competition_result.individual_result.detail.High_bid                 as individual_high_bid,
        coe_competition_result.individual_result.detail.High_bidders             as individual_high_bidders,
        coe_competition_result.individual_result.detail.Kilos                    as individual_kilos,
        coe_competition_result.individual_result.detail.Month                    as individual_month,
        coe_competition_result.individual_result.detail.Other                    as individual_attributes_other,
        coe_competition_result.individual_result.detail.Overall                  as individual_attributes_overall,
        coe_competition_result.individual_result.detail.Processing_system        as individual_processing_system,
        coe_competition_result.individual_result.detail.Program                  as individual_program,
        coe_competition_result.individual_result.detail.Rank                     as individual_rank,
        coe_competition_result.individual_result.detail.Region                   as individual_region,
        coe_competition_result.individual_result.detail.Size__30kg_boxes_        as individual_size__30kg_boxes,
        coe_competition_result.individual_result.detail.Total_value              as individual_total_value,
        coe_competition_result.individual_result.detail.Variety_                 as individual_variety,
        coe_competition_result.individual_result.detail.Year                     as individual_year,
    -- renewal site
        coe_competition_result.individual_result.farm_information                as individual_farm_information,
        coe_competition_result.individual_result.gallery                         as individual_gallery,
        coe_competition_result.individual_result.images                          as individual_images,
        coe_competition_result.individual_result.location                        as individual_location,
        coe_competition_result.individual_result.lot_information                 as individual_lot_information,
        coe_competition_result.individual_result.score                           as individual_score,
        coe_competition_result.individual_result.similar_farm                    as individual_similar_farm,
    from
        coe_competition_results
        , unnest(json_query_array(coe_competition_results_array)) as coe_competition_result
)

, tmp as (
    select except(individual_farm_information, individual_farm_name, individual_farm_name, individual_farm_size, individual_farmer_rep,\n
        individual_lot_information,\
        individual_score\
    )
    -- integrate
    -- farm_information
        case
            when individual_farm_information['Altitude'] is not null then individual_farm_information['Altitude']
            when individual_altitude is not null then individual_altitude
            else null
        end as individual_farm_information_altitude,
        case
            when individual_farm_information['Farm Name'] is not null then individual_farm_information['Farm Name']
            when individual_farm_name is not null then individual_farm_name
            else null
        end as individual_farm_information_farm_name,
        case
            when individual_farm_information['Farm Size'] is not null then individual_farm_information['Farm Size']
            when individual_farm_size is not null then individual_farm_size
            else null
        end as individual_farm_information_farm_size,
        case
            when individual_farm_information['Farmer'] is not null then individual_farm_information['Farmer']
            when individual_farmer_rep is not null then individual_farmer_rep
            else null
        end as individual_farm_information_farmer_rep_,
    --  lot_information
        {# Acidity
1	Aroma / Flavor
2	Overall
3	Processing System
4	Variety
5	Year #}
    -- individual_score
    {# Awards
1	Rank
2	Score #}
    --
        individual_gallery,
        individual_images,
        individual_location,
        individual_similar_farm,
        *
    from
        get_json_value_and_make_flag
)

, cast_value as (
    select
        program_url,
    -- rank
        case
            when rank.text is not null then cast(json_value(rank, '$.text') as string)
            else string(rank)
        end as table_rank,
    -- score
        case
            when score.text is not null then cast(replace(cast(json_value(score, '$.text') as string), ',', '.') as numeric)
            else cast(replace(string(score), ',', '.') as numeric)
        end as table_score,  
    -- farm / farmer
        case
            when farm_cws.text is not null then cast(json_value(farm_cws, '$.text') as string)
            else string(farm_cws)
        end as table_farm_cws,
        cws_flg,
        case
            when farmer_rep_org.text is not null then cast(json_value(farmer_rep_org, '$.text') as string)
            else string(farmer_rep_org)
        end as table_farmer_rep_org,
        rep_org_flg,
    -- variety
        case
            when variety.text is not null then cast(json_value(variety, '$.text') as string)
            else string(variety)
        end as table_variety,
    -- process
        case
            when process.text is not null then cast(json_value(process, '$.text') as string)
            else string(process)
        end as table_process,
    -- region
        case
            when region.text is not null then cast(json_value(region, '$.text') as string)
            else string(region)
        end as table_region,
    -- woreda
        case
            when woreda.text is not null then cast(json_value(woreda, '$.text') as string)
            else string(woreda)
        end as table_woreda,
    -- zone
        case
            when zone.text is not null then cast(json_value(zone, '$.text') as string)
            else string(zone)
        end as table_zone,
    -- lot No.
        string(lot_no) as table_lot_no,
    -- size
        case
            when size.text is not null then cast(json_value(size, '$.text') as string)
            else string(size)
        end as table_size,
        size_30kg_boxes_flg,
    -- weight
        case
            when weight.text is not null then cast(json_value(weight, '$.text') as string)
            else string(weight)
        end as table_weight,
        weight_kg_lbs_flg,
    -- individual result
        string(individual_url) as individual_url,
        site_flg,
        individual_description,
        individual_attributes_acidity,
        individual_altitude,
        individual_attributes_aroma_flavor,
        individual_auction,
        individual_auction_lot_size_kg,
        individual_auction_lot_size_lbs,
        individual_business_address,
        individual_business_phone_number,
        individual_business_website_address,
        individual_certifications,
        individual_city,
        individual_attributes_coffee_characteristics,
        individual_coffee_growing_area,
        individual_country,
        individual_farm_name,
        individual_farm_size,
        individual_farmer_rep,
        individual_high_bid,
        individual_high_bidders,
        individual_kilos,
        individual_month,
        individual_attributes_other,
        individual_attributes_overall,
        individual_processing_system,
        individual_program,
        individual_rank,
        individual_region,
        individual_size__30kg_boxes,
        individual_total_value,
        individual_variety,
        individual_year,
        individual_farm_information,
        individual_gallery,
        individual_images,
        individual_location,
        individual_lot_information,
        individual_score,
        individual_similar_farm,
    from
        get_json_value_and_make_flag
)

, final as (
    select
        *
    from
        cast_value
)

{# select * from final #}
select * from tmp