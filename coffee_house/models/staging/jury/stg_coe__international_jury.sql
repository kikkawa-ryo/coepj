with

source as (
    select * from {{ ref('base_cup_of_excellence') }}
)

, international_juries as (
    select
        url,
        case
            when contents.International_Jury is not null then contents.International_Jury
            else null
        end as international_juries_array
    from
        source
)

, final as (
    select
        * except(international_juries_array)
    from
        international_juries
        , unnest(json_query_array(international_juries_array)) as international_jury
)

select * from final