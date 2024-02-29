{%- macro get_blank_adjusted_bigram(threshold, n) %}
    {%- if execute %}
    {%- set query -%} 
        with processed_descriptions as (
            SELECT acidity_str_agg, aroma_flavor_str_agg, other_str_agg, overall_str_agg, characteristics_str_agg
            FROM {{ ref("base_cup_of_excellence__coe_results_coffee_descriptions_processing") }}
        )
        , union_descriptions as (
            SELECT acidity_str_agg as descriptions FROM processed_descriptions
            union all
            SELECT aroma_flavor_str_agg FROM processed_descriptions
            union all
            SELECT other_str_agg FROM processed_descriptions
            union all
            SELECT overall_str_agg FROM processed_descriptions
            union all
            SELECT characteristics_str_agg FROM processed_descriptions
        )
        , descriptions_agg as (
            select
                STRING_AGG(descriptions, ",") as description_agg
            from
                union_descriptions
        )
        , bag_of_words as (
            select
                BAG_OF_WORDS(split(description_agg, ",")) bow
            from
                descriptions_agg
        )
        , ngram_and_count as (
            select
                f.term, f.count, ARRAY_LENGTH(REGEXP_EXTRACT_ALL(f.term, ' ')) + 1 as ngram
            from
                bag_of_words , unnest(bow) f
        )
        , bigrams as (
            select term as bigram
            from ngram_and_count
            where ngram = 2
        )
        SELECT
            bigram as temporary_true_bigram
        FROM
            bigrams
        where exists (
            select
                bigram
            from
                unnest(array(select bigram from bigrams)) as candidate_bigram
            where
                regexp_contains(REGEXP_REPLACE(bigram, "(.+)\s(.+)", "\\2\s\\1"), candidate_bigram)
        )
    {%- endset -%}
    {{ return(run_query(query).columns[0].values()) }}
    {%- endif %}
{%- endmacro %}