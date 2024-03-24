with

    source as (select * from {{ ref('base_coe__competition_results') }}),
    flatten_table as (
        select 0 as is_fixed, offset, url, coe_competition_result
        from
            source,
            unnest(
                json_query_array(coe_competition_results_array)
            ) as coe_competition_result
        with
        offset
    ),
    concat_table as (
        select *
        from flatten_table
        union all
        select *
        from {{ ref('seed_coe__competition_results__fixed_data') }}
    ),
    filtered_table as (
        select
            offset,
            url as program_url,
            concat(regexp_extract(url, r'https://.+?/(.+)/'), '_', offset) as id,
            regexp_extract(url, r'https://.+?/.*(\d{4}).*/') as year,
            coe_competition_result
        from concat_table
        -- 修正前データを削除
        qualify rank() over (partition by offset, url order by is_fixed desc) = 1
        order by url,
        offset
    )

select *
from filtered_table
