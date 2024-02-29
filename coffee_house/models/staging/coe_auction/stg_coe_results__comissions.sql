with

source as (
    select * from {{ ref('stg_coe_results') }}
)

, comissions as (
    select
        url,
        case
            when contents.Auction_Commissions is not null then contents.Auction_Commissions
            when contents.Organizing_Country_Commissions is not null then contents.Organizing_Country_Commissions
            else null
        end as comissions_array
    from
        source
)

, final as (
    select
        * except(comissions_array)
    from
        comissions
        , unnest(json_query_array(comissions_array)) as comission
)

select * from final