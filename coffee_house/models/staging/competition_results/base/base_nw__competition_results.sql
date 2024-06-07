with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

nw_competition_results as (
    select
        country,
        year,
        program,
        "nw" as award_category,
        case
            {% set columns = ["NW_Competition_Results", "Nw_Competition_Results", "National_Winners", "National_Winners_"] %}
            {% for column in columns %}
                when
                    contents.{{ column }} is not null
                    then contents.{{ column }}
            {% endfor %}
            else null
        end as nw_competition_results_array
    from source
)

select *,
from nw_competition_results
