with

    source as (select * from {{ ref('base_coe__commissions') }}),
    flatten_table as (
        select
            offset,
            url as program_url,
            concat(regexp_extract(url, r'https://.+?/(.+)/'), '_', offset) as id,
            regexp_extract(url, r'https://.+?/.*(\d{4}).*/') as year,
            commissions
        from source, unnest(json_query_array(commissions_array)) as commissions
        with
        offset
    )

select *
from flatten_table
