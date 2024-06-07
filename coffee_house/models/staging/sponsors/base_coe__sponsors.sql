with

source as (select *, from {{ ref('base_cup_of_excellence') }}),

sponsors as (
    select 1 as tmp,
    {# from source #}
)

select *,
from sponsors
