with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

coe_auciton_results as (
    select
        year,
        program,
        "coe" as award_category,
        case
            {% set columns = ["COE_Auction_Results", "Coe_Auction_Results"] %}
            {% for column in columns %}
                when
                    contents.{{ column }} is not null
                    then contents.{{ column }}
            {% endfor %}
            else null
        end as coe_auction_results_array
    from source
)

select *,
from coe_auciton_results
