with

    source as (select * from {{ ref('base_coe__auction_results') }}),
    flatten_table as (
        select
            offset,
            url as program_url,
            concat(regexp_extract(url, r'https://.+?/(.+)/'), '_', offset) as id,
            regexp_extract(url, r'https://.+?/.*(\d{4}).*/') as year,
            coe_auciton_result
        from
            source,
            unnest(json_query_array(coe_auction_results_array)) as coe_auciton_result
        with
        offset
    )

select *
from flatten_table
