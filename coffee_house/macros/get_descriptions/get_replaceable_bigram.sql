{%- macro get_replaceable_bigram(model) %}
    {%- if execute %}
        {%- set query -%}
        with processed_descriptions as (
            SELECT acidity_str_agg, aroma_flavor_str_agg, other_str_agg, overall_str_agg, characteristics_str_agg
            {# FROM {{ ref("{{ model }}") }} #}
            FROM {{ ref("base_coe__competition_results__coffee_descriptions__ngram_split") }}
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
            select
                term as bigram,
                count as cnt
            from
                ngram_and_count
            where
                ngram = 2
        )
        SELECT
            x.bigram
        FROM
            bigrams x
        left join
            bigrams y 
        on
            x.bigram = REGEXP_REPLACE(y.bigram, r"(\w+)\s(\w+)", "\\2 \\1")
        where
            y.bigram is not null
            and x.cnt > y.cnt
            and x.cnt / y.cnt > 15
        {%- endset -%}
        {{ return(run_query(query).columns[0].values()) }}
    {%- endif %}
{%- endmacro %}
