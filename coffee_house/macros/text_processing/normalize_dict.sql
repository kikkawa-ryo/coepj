{% macro get_normalize_dict() %}
    {{ return([
        {"regexp":"[–|—]", "replacement":"-"},
        {"regexp":"[‘|’]", "replacement":"\\'"},

        {"regexp":"[ãá]", "replacement":"a"},
        {"regexp":"[ç]", "replacement":"c"},
        {"regexp":"[èéê]", "replacement":"e"},
        {"regexp":"[í]", "replacement":"i"},
        {"regexp":"[ñ]", "replacement":"n"},
        {"regexp":"[ó]", "replacement":"o"},
        {"regexp":"[úû]", "replacement":"u"}
        ])
    }}
{% endmacro %}