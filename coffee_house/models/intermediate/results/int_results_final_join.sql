with
panel_table as (
    select
        * except(individual_result)
    from 
        {{ ref('int_results_union_all_segments') }}
),
individual_table as (
    select
        *,
    from 
        {{ ref('int_results_expand_detail_columns') }}
),
final as (
    select
        {# "high_bid",  "score", "total_value", "year"#}
        {% set duplicate_columns = ["result_key", "country", "rank", "region", "variety"] %}
        panel_table.* except({% for duplicate_column in duplicate_columns %}{{duplicate_column}}{% if not loop.last %}, {% endif %}{% endfor %}),
        individual_table.* except({% for duplicate_column in duplicate_columns %}{{duplicate_column}}{% if not loop.last %}, {% endif %}{% endfor %}),
        {% for duplicate_column in duplicate_columns -%}
        if(panel_table.{{duplicate_column}} is null, individual_table.{{duplicate_column}}, panel_table.{{duplicate_column}}) as {{duplicate_column}},
        {% endfor %}
    from
        panel_table
    left join individual_table
        on panel_table.result_key = individual_table.result_key
)
select
    *
from
    final
