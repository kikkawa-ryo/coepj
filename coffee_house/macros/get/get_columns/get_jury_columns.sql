{% macro get_jury_columns() %}
    {{ return(
        [ {"alias": "jury_name", "columns": ["Name", "National_Judges", "Nombre"]}
        , {"alias": "jury_organization", "columns": ["Company", "Gcc_Lab", "Lab", "Organization"]}
        ]
        )
    }}
{% endmacro %}
