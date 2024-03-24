with

    source as (select * from {{ ref('base_cup_of_excellence') }}),
    nw_competition_results as (
        select
            url,
            case
                when contents.nw_competition_results is not null
                then contents.nw_competition_results
                when contents.national_winners is not null
                then contents.national_winners
                when contents.national_winners_ is not null
                then contents.national_winners_
                else null
            end as nw_competition_results_array
        from source
    ),
    final as (
        select * except (nw_competition_results_array)
        from
            nw_competition_results,
            unnest(
                json_query_array(nw_competition_results_array)
            ) as nw_competition_result
    )

select *
from final
