{{ config(
    materialized="table"
) }}

with
source as (select *, from {{ source('staging', 'cup_of_excellence') }}),

deduplicated as (
    select
        url as program_url,
        cast(regexp_extract(url, r"https://.+?/.*(\d{4}).*/") as int) as year,
        case
            when
                regexp_contains(url, "/costa-rica-coe-2017/")
                then "costa-rica-2017"
            when
                regexp_contains(url, "/brazil-naturals-2015/")
                then "brazil-naturals-december-2015"
            else regexp_extract(url, r"https://.+?/(.+)/")
        end as program,
        array_agg(src order by src.url desc limit 1)[offset(0)] as src,
    from source as src
    group by url
),

final as (
    select
        program_url,
        year,
        program,
        parse_json(normalize(to_json_string(src.contents), nfkc)) as contents,
        parse_json(normalize(to_json_string(src.page_info), nfkc)) as page_info,
    from
        deduplicated
)

select *, from final
