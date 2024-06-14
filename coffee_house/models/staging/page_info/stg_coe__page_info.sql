with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

renamed as (
    select
        program_key,
        JSON_VALUE_ARRAY(page_info.remarks) remarks,
        JSON_VALUE_ARRAY(page_info.individual_flag) individual_flag,
        JSON_VALUE_ARRAY(page_info.individual_unique_links) individual_unique_links,
        JSON_VALUE_ARRAY(page_info.visited_result_url_list) visited_result_url_list,
        struct(
            ARRAY(select li from unnest(JSON_VALUE_ARRAY(page_info.description[0].li)) li WITH OFFSET order by offset) as li,
            ARRAY(select p from unnest(JSON_VALUE_ARRAY(page_info.description[0].p)) p WITH OFFSET order by offset) as p
        ) description,
    from source
)

select *,
from renamed
