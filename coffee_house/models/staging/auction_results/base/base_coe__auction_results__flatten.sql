with

source as (
    select * from {{ ref('base_coe__auction_results') }}
)

, flatten_table as (
    select
        OFFSET,
        url as program_url,
        CONCAT(REGEXP_EXTRACT(url, r'https://.+?/(.+)/'), '_', offset) as id,
        REGEXP_EXTRACT(url, r'https://.+?/.*(\d{4}).*/') as year,
        coe_auciton_result
    from
        source
        , unnest(json_query_array(coe_auction_results_array)) as coe_auciton_result with OFFSET
)

select * from flatten_table
