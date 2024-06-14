with test_target as (
    select
        id_rank_competition,
        id_rank_auction,
        farm_cws_competition,
        farm_cws_auction,
    from {{ ref('int_results_union_all_segments')}}
    WHERE
        id_rank_competition != id_rank_auction
),

processing_0 as (
    select
        id_rank_competition,
        id_rank_auction,
        NORMALIZE_AND_CASEFOLD(farm_cws_competition, NFKC) as farm_cws_competition,
        NORMALIZE_AND_CASEFOLD(farm_cws_auction, NFKC) as farm_cws_auction,
    from
        test_target
),
{%- set fix_dict_list = get_normalize_dict() -%}
{% for fix_dict in fix_dict_list %}
    {% set before_index = loop.index0 |string -%}
    {% set current_index = loop.index |string -%}
    {{ "processing_" ~ current_index }} as (
        select
            id_rank_competition,
            id_rank_auction,
            regexp_replace(farm_cws_competition, r"{{ fix_dict.regexp }}", "{{ fix_dict.replacement }}") as farm_cws_competition,
            regexp_replace(farm_cws_auction, r"{{ fix_dict.regexp }}", "{{ fix_dict.replacement }}") as farm_cws_auction,
        from {{ "processing_" ~ before_index }}
    ),
    {%- if loop.last %}
        processing as (
            select *, from {{ "processing_" ~ current_index }}
        ),
    {% endif -%}
{% endfor -%}

test_target_processed as (
    select
        id_rank_competition,
        id_rank_auction,
        farm_cws_competition,
        farm_cws_auction,
    from
        processing
)

select *
from test_target_processed
WHERE
    id_rank_competition != id_rank_auction
    and farm_cws_competition != farm_cws_auction