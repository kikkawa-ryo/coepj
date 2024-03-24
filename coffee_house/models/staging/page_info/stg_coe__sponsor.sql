with

    source as (select * from {{ ref('base_cup_of_excellence') }}),
    national_juries as (
        select
            url,
            case
                when contents.national_jury is not null
                then contents.national_jury
                else null
            end as national_juries_array
        from source
    ),
    final as (
        select * except (national_juries_array)
        from
            national_juries,
            unnest(json_query_array(national_juries_array)) as national_jury
    )

select *
from final
