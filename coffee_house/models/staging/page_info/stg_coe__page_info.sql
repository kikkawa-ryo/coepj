with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

renamed as (
    select
        program_key,
        program_id,
        year,
        page_info.remarks,
        page_info.individual_flag,
        page_info.individual_unique_links,
        page_info.visited_result_url_list,
        page_info.description[0].li,
        page_info.description[0].p,
    from source
)

select *,
from renamed
