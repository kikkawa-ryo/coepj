with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

coe_competition_results as (
    select
        country,
        year,
        program,
        "coe" as award_category,
        case
            {% set columns = ["COE_Competition_Results", "Coe_Competition_Results", "Winning_Farms", "Winning_Farms_"] %}
            {% for column in columns %}
                when
                    contents.{{ column }} is not null
                    then contents.{{ column }}
            {% endfor %}
            else null
        end as coe_competition_results_array
    from source
)

select *,
from coe_competition_results
