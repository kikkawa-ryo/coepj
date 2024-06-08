with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

commissions as (
    select
        program_key,
        program_id,
        country,
        year,
        "coe" as award_category,
        case
            {% set columns = ["Auction_Commissions", "Organizing_Country_Commissions"] %}
            {% for column in columns %}
                when
                    contents.{{ column }} is not null
                    then contents.{{ column }}
            {% endfor %}
            else null
        end as commissions_array
    from source
)

select *,
from commissions
