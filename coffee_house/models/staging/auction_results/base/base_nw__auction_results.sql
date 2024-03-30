with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

nw_auciton_results as (
    select
        country,
        year,
        program,
        "nw" as award_category,
        case
            {% set columns = ["NW_Auction_Results", "Nw_Auction_Results"] %}
            {% for column in columns %}
                when
                    contents.{{ column }} is not null
                    then contents.{{ column }}
            {% endfor %}
            else null
        end as nw_auction_results_array
    from source
)

select *,
from nw_auciton_results
