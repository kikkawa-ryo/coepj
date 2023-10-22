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

, final as (
    select
        coe_competition_results.url,
    -- rank
        case
            when coe_competition_result.RANK is not null then json_value(coe_competition_result, '$.RANK')
            when coe_competition_result.Rank is not null then json_value(coe_competition_result, '$.Rank')
            else null
        end as rank,
    -- score
        case
            when coe_competition_result.SCORE is not null then cast(replace(json_value(coe_competition_result, '$.SCORE'), ',', '') as numeric)
            when coe_competition_result.Score is not null then cast(replace(json_value(coe_competition_result, '$.Score'), ',', '') as numeric)
            else null
        end as score,  
    -- farm / farmer
        case
            when coe_competition_result.FARM is not null then json_value(coe_competition_result, '$.FARM')
            when coe_competition_result.Farm is not null then json_value(coe_competition_result, '$.Farm')
            when coe_competition_result.Farm_Name is not null then json_value(coe_competition_result, '$.Farm_Name')
            when coe_competition_result.FARM_CWS is not null then json_value(coe_competition_result, '$.FARM_CWS')
            when coe_competition_result.FARM___CWS is not null then json_value(coe_competition_result, '$.FARM___CWS')
            when coe_competition_result.Farm___CWS is not null then json_value(coe_competition_result, '$.Farm___CWS')
            else null
        end as farm_cws,
        case
            when coe_competition_result.FARM_CWS is not null then 1
            when coe_competition_result.FARM___CWS is not null then 1
            when coe_competition_result.Farm___CWS is not null then 1
            else 0
        end as cws_flg,
        case
            when coe_competition_result.FARMER is not null then json_value(coe_competition_result, '$.FARMER')
            when coe_competition_result.Farmer is not null then json_value(coe_competition_result, '$.Farmer')
            when coe_competition_result.FARMER___ORGANIZATION is not null then json_value(coe_competition_result, '$.FARMER___ORGANIZATION')
            when coe_competition_result.FARMER___REPRESENTATIVE is not null then json_value(coe_competition_result, '$.FARMER___REPRESENTATIVE')
            when coe_competition_result.Farmer___Representative is not null then json_value(coe_competition_result, '$.Farmer___Representative')
            when coe_competition_result.PRODUCER is not null then json_value(coe_competition_result, '$.PRODUCER')
            when coe_competition_result.Producer is not null then json_value(coe_competition_result, '$.Producer')
            when coe_competition_result.OWNER is not null then json_value(coe_competition_result, '$.OWNER')
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
            when coe_competition_result.VARIETY is not null then json_value(coe_competition_result, '$.VARIETY')
            when coe_competition_result.Variety is not null then json_value(coe_competition_result, '$.Variety')
            else null
        end as variety,
    -- process
        case
            when coe_competition_result.PROCESS is not null then json_value(coe_competition_result, '$.PROCESS')
            when coe_competition_result.PROCESSING is not null then json_value(coe_competition_result, '$.PROCESSING')
            when coe_competition_result.Process is not null then json_value(coe_competition_result, '$.Process')
            when coe_competition_result.Processing is not null then json_value(coe_competition_result, '$.Processing')
            else null
        end as process,
    -- region
        case
            when coe_competition_result.REGION is not null then json_value(coe_competition_result, '$.REGION')
            when coe_competition_result.Region is not null then json_value(coe_competition_result, '$.Region')
            else null
        end as region,
    -- woreda
        case
            when coe_competition_result.WOREDA is not null then json_value(coe_competition_result, '$.WOREDA')
            when coe_competition_result.Woreda is not null then json_value(coe_competition_result, '$.Woreda')
            else null
        end as woreda,
    -- zone
        case
            when coe_competition_result.ZONE is not null then json_value(coe_competition_result, '$.ZONE')
            when coe_competition_result.Zone is not null then json_value(coe_competition_result, '$.Zone')
            else null
        end as zone,
    -- lot No.
        -- cast(json_value(coe_competition_result, '$.LOT_NO_') as int) as lot_no,
        json_value(coe_competition_result, '$.LOT_NO_') as lot_no,
    -- size
        case
            -- when coe_competition_result.SIZE is not null then cast(json_value(coe_competition_result, '$.SIZE') as int)
            -- when coe_competition_result.Size is not null then cast(json_value(coe_competition_result, '$.Size') as int)
            -- when coe_competition_result.SIZE__30KG_BOXES_ is not null then cast(json_value(coe_competition_result, '$.SIZE__30KG_BOXES_') as int)
            -- when coe_competition_result.Size__30kg_Boxes_ is not null then cast(json_value(coe_competition_result, '$.Size__30kg_Boxes_') as int)
            when coe_competition_result.SIZE is not null then json_value(coe_competition_result, '$.SIZE')
            when coe_competition_result.Size is not null then json_value(coe_competition_result, '$.Size')
            when coe_competition_result.SIZE__30KG_BOXES_ is not null then json_value(coe_competition_result, '$.SIZE__30KG_BOXES_')
            when coe_competition_result.Size__30kg_Boxes_ is not null then json_value(coe_competition_result, '$.Size__30kg_Boxes_')
            else null
        end as size,
        case
            when coe_competition_result.SIZE__30KG_BOXES_ is not null then 1
            when coe_competition_result.Size__30kg_Boxes_ is not null then 1
            else 0
        end as size_30kg_boxes_flg,
    -- weight
        case
            when coe_competition_result.WEIGHT__KG_ is not null then cast(json_value(coe_competition_result, '$.WEIGHT__KG_') as int)
            when coe_competition_result.WEIGHT__kg_ is not null then cast(json_value(coe_competition_result, '$.WEIGHT__kg_') as int)
            when coe_competition_result.Weight__kg_ is not null then cast(json_value(coe_competition_result, '$.Weight__kg_') as int)
            when coe_competition_result.Weight_Lbs_ is not null then cast(json_value(coe_competition_result, '$.Weight_Lbs_') as int)
            when coe_competition_result.Weight___lbs is not null then cast(json_value(coe_competition_result, '$.Weight___lbs') as int)
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
    -- indivudal result
        json_value(coe_competition_result, '$.url') as indivudal_url,
        coe_competition_result.individual_result
    from
        coe_competition_results
        , unnest(json_query_array(coe_competition_results_array)) as coe_competition_result
)

select * from final