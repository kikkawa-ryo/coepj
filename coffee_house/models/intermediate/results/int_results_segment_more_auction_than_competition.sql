with

stg__competition_results as (
    select *, from {{ ref('stg__competition_results') }}
),

stg__auction_results as (
    select *, from {{ ref('stg__auction_results') }} t
    where
        concat(
            t.program_key, t.award_category
        ) in (
            select concat(s.program_key, s.award_category),
            from {{ ref('int_results_segmenting_for_join') }} s
            where flg = 4
        )
),

stg__commissions as (select *, from {{ ref('stg__commissions') }}),

more_auction_than_competition as (
    select
        stg__auction_results.id_offset as result_key,
        {%- set columns_info = get_cup_of_excellence_columns() -%}
        {# common #}
        {% for column_dict in columns_info.common %}
        case
            {% for target_and_priority in column_dict.target_and_priority %}
            {%- if target_and_priority == 1 %}
            when stg__competition_results.{{ column_dict.column }} is not null
                then stg__competition_results.{{ column_dict.column }}
            {% endif -%}
            {%- if target_and_priority == 2 %}
            when stg__auction_results.{{ column_dict.column }} is not null
                then stg__auction_results.{{ column_dict.column }}
            {% endif -%}
            {%- if target_and_priority == 3 %}
            when stg__commissions.{{ column_dict.column }} is not null
                then stg__commissions.{{ column_dict.column }}
            {% endif -%}
            {% endfor %}
            else null
        end as {{ column_dict.column }}
        {%- if not loop.last %},{% endif -%}
        {% endfor %},
        {# competition #}
        {%- for column in columns_info.competition %}
        stg__competition_results.{{ column }} as {{ column ~ "_competition" }}
        {%- if not loop.last %},{% endif -%}
        {% endfor %},
        {# auction #}
        {%- for column in columns_info.auction %}
        stg__auction_results.{{ column }} as {{ column ~ "_auction" }}
        {%- if not loop.last %},{% endif -%}
        {% endfor %},
        {# commissions #}
        {%- for column in columns_info.commissions %}
        stg__commissions.{{ column }} as {{ column ~ "_commissions" }}
        {%- if not loop.last %},{% endif -%}
        {% endfor %},
        case
            when CEILING(stg__competition_results.weight_lb / stg__competition_results.weight_kg * 1000) / 1000 = 2.205
                then stg__competition_results.weight_lb
            when CEILING(stg__auction_results.weight_lb / stg__auction_results.weight_kg * 1000) / 1000 = 2.205
                then stg__auction_results.weight_lb
            when CEILING(stg__commissions.weight_lb / stg__commissions.weight_kg * 1000) / 1000 = 2.205
                then stg__commissions.weight_lb
            else null
        end as weight_lb,
        case
            when CEILING(stg__competition_results.weight_lb / stg__competition_results.weight_kg * 1000) / 1000 = 2.205
                then stg__competition_results.weight_kg
            when CEILING(stg__auction_results.weight_lb / stg__auction_results.weight_kg * 1000) / 1000 = 2.205
                then stg__auction_results.weight_kg
            when CEILING(stg__commissions.weight_lb / stg__commissions.weight_kg * 1000) / 1000 = 2.205
                then stg__commissions.weight_kg
            else null
        end as weight_kg,
        case
            {# 複数×have_partial #}
            when (stg__competition_results.lot_size != stg__auction_results.lot_size or stg__auction_results.lot_size != stg__commissions.lot_size)
                then (select cast(max(x) as int) from unnest(split(concat(IFNULL(stg__competition_results.lot_size,0), ",", IFNULL(stg__auction_results.lot_size,0), ",", IFNULL(stg__commissions.lot_size,0)), ",")) x)
            when stg__competition_results.lot_size is not null
                then stg__competition_results.lot_size
            when stg__auction_results.lot_size is not null
                then stg__auction_results.lot_size
            when stg__commissions.lot_size is not null
                then stg__commissions.lot_size
            else null
        end as lot_size,
        case
            when stg__competition_results.individual_result is not null
                then stg__competition_results.individual_result
            when stg__auction_results.individual_result is not null
                then stg__auction_results.individual_result
            when stg__commissions.individual_result is not null
                then stg__commissions.individual_result
            else null
        end as individual_result,
        case
            when stg__competition_results.individual_result is not null
                then stg__competition_results.url
            when stg__auction_results.individual_result is not null
                then stg__auction_results.url
            when stg__commissions.individual_result is not null
                then stg__commissions.url
            else null
        end as url,
    from
        stg__auction_results
    left join stg__competition_results
        on
            stg__auction_results.program_key = stg__competition_results.program_key
            and stg__auction_results.award_category
            = stg__competition_results.award_category
            and stg__auction_results.rank_no = stg__competition_results.rank_no
    left join stg__commissions
        on stg__auction_results.id_offset = stg__commissions.id_offset
)
select *, from more_auction_than_competition