with

stg__competition_results as (
    select *, from {{ ref('stg__competition_results') }}
),

stg__auction_results as (select *, from {{ ref('stg__auction_results') }}),

competition_results_cnt as (
    select
        program_key,
        award_category,
        ifnull(competition_offset_cnt, 0) as competition_offset_cnt,
        ifnull(competition_rank_cnt, 0) as competition_rank_cnt,
    from (
        select
            program_key,
            award_category,
            count(id_offset) as competition_offset_cnt,
            count(id_rank) as competition_rank_cnt,
        from
            stg__competition_results
        group by
            program_key,
            award_category
    )
),

auction_results_cnt as (
    select
        program_key,
        award_category,
        ifnull(auction_offset_cnt, 0) as auction_offset_cnt,
        ifnull(auction_rank_cnt, 0) as auction_rank_cnt,
    from (
        select
            program_key,
            award_category,
            count(id_offset) as auction_offset_cnt,
            count(id_rank) as auction_rank_cnt,
        from
            stg__auction_results
        group by
            program_key,
            award_category
    )
),

target_segmentation as (
    select
        competition_results_cnt.*,
        auction_results_cnt.* except (program_key, award_category),
        CASE
            WHEN auction_offset_cnt is null THEN 1
            WHEN competition_offset_cnt = auction_offset_cnt and auction_rank_cnt = 0 THEN 2
            WHEN competition_offset_cnt = auction_offset_cnt THEN 3
            WHEN competition_offset_cnt < auction_offset_cnt THEN 4
            WHEN competition_offset_cnt > auction_offset_cnt and auction_rank_cnt = 0 THEN 5
            WHEN competition_offset_cnt > auction_offset_cnt THEN 6
            ELSE 0
        END AS flg,
    from
        competition_results_cnt
    left join auction_results_cnt
        on
            competition_results_cnt.program_key = auction_results_cnt.program_key
            and competition_results_cnt.award_category = auction_results_cnt.award_category
)

select *, from target_segmentation