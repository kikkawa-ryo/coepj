with

source as (
    select * from {{ ref('base_coe__competition_results') }}
)

, flatten_table as (
    select
        0 as is_fixed,
        OFFSET,
        url,
        coe_competition_result
    from
        source
        , unnest(json_query_array(coe_competition_results_array)) as coe_competition_result with OFFSET
)

, concat_table as (
    select * from flatten_table
    union all
    select * from {{ ref('seed_coe__competition_results__fixed_data') }}
)

, filtered_table as (
    select 
        OFFSET,
        url as program_url,
        CONCAT(REGEXP_EXTRACT(url, r'https://.+?/(.+)/'), '_', offset) as id,
        REGEXP_EXTRACT(url, r'https://.+?/.*(\d{4}).*/') as year,
        coe_competition_result
    from 
        concat_table
    -- 修正前データを削除
    QUALIFY
        RANK() OVER (PARTITION BY OFFSET,url ORDER BY is_fixed DESC) = 1
    order by
        url, offset
)

select * from filtered_table
