with

stg__competition_results as (
    select *, from {{ ref('stg__competition_results') }}
),

stg__auction_results as (select *, from {{ ref('stg__auction_results') }}),

stg__commissions as (select *, from {{ ref('stg__commissions') }}),

target_segmentation as (
    select * from {{ ref('int_results_segmenting_for_join') }}
),

majority as (
    select
        {# 1 flg, #}
        {%- set columns_info = get_cup_of_excellence_columns() -%}
        {# common #}
        {% for column in columns_info.common %}
        case
            when stg__competition_results.{{ column }} is not null
                then stg__competition_results.{{ column }}
            when stg__auction_results.{{ column }} is not null
                then stg__auction_results.{{ column }}
            when stg__commissions.{{ column }} is not null
                then stg__commissions.{{ column }}
            else null
        end as {{ column }}
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
        stg__competition_results
    left join stg__auction_results
        on stg__competition_results.id_offset = stg__auction_results.id_offset
    left join stg__commissions
        on stg__auction_results.id_offset = stg__commissions.id_offset
    where
        concat(
            stg__competition_results.program,
            stg__competition_results.award_category
        ) in (
            select concat(program, award_category),
            from target_segmentation
            where flg in (0, 1, 2)
        )
)
select *, from majority