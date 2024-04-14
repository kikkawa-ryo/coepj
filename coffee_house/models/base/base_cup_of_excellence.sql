{{ config(
    materialized="table"
) }}

with
source as (select *, from {{ source('staging', 'cup_of_excellence') }}),

deduplicated as (
{{ dbt_utils.deduplicate(
    relation='source',
    partition_by='url',
    order_by='url',
   )
}}
),

final as (
    select
        url as program_url,
        cast(regexp_extract(url, r"https://.+?/.*(\d{4}).*/") as int) as year,
        case
            when regexp_contains(url, "costa-rica") then "costa-rica"
            when regexp_contains(url, "el-salvador") then "el-salvador"
            else regexp_extract(url, r"https://.+?/(\w+)-?.*-\d+-?.+?/")
        end as country,
        case
            when
                regexp_contains(url, "/costa-rica-coe-2017/")
                then "costa-rica-2017"
            when
                regexp_contains(url, "/brazil-naturals-2015/")
                then "brazil-naturals-december-2015"
            else regexp_extract(url, r"https://.+?/(.+)/")
        end as program,
        parse_json(normalize(to_json_string(contents), nfkc)) as contents,
        parse_json(normalize(to_json_string(page_info), nfkc)) as page_info,
    from
        deduplicated
)

select *, from final
