with
tmp as (
    select
        id,
        case
            when JSON_EXTRACT_ARRAY(individual_result, '$.images') is not null
                then JSON_EXTRACT_ARRAY(individual_result, '$.images')
            when JSON_EXTRACT_ARRAY(individual_result, '$.gallery') is not null
                then JSON_EXTRACT_ARRAY(individual_result, '$.gallery')
            else null
        end as images_array,
    from
        {{ ref('int_results_union_all_segments') }}      
),
final as (
    select
        id,
        json_value(image_url_json) as image_url,
    from
        tmp
        , unnest(images_array) as image_url_json
)
select *, from final
