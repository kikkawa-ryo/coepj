with

source as (
    select * from {{ ref('base_cup_of_excellence') }}
)

, nw_competition_results as (
    select
        url,
        case
            when contents.NW_Competition_Results is not null then contents.NW_Competition_Results
            when contents.National_Winners is not null then contents.National_Winners
            when contents.National_Winners_ is not null then contents.National_Winners_
            else null
        end as nw_competition_results_array
    from
        source
)

, final as (
    select
        * except(nw_competition_results_array)
    from
        nw_competition_results
        , unnest(json_query_array(nw_competition_results_array)) as nw_competition_result
)

select * from final