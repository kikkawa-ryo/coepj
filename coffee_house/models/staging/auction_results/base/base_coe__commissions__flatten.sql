with

source as (
    select * from {{ ref('base_coe__commissions') }}
)

, flatten_table as (
    select
        OFFSET,
        url as program_url,
        CONCAT(REGEXP_EXTRACT(url, r'https://.+?/(.+)/'), '_', offset) as id,
        REGEXP_EXTRACT(url, r'https://.+?/.*(\d{4}).*/') as year,
        commissions
    from
        source
        , unnest(json_query_array(commissions_array)) as commissions with OFFSET
)

select * from flatten_table
