{{ config(
    materialized="table"
) }}

with

flatten_table as (
    select * from {{ ref('base_coe__commissions__flatten') }}
)

, get_columns as (
    select
        OFFSET,
        program_url,
        id,
        year,
    from
        flatten_table
)

select * from get_columns