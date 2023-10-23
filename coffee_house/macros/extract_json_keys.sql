{% macro extract_json_keys(json_string) %}
CREATE TEMP FUNCTION extract_json_keys(input STRING)
RETURNS ARRAY<STRING>
LANGUAGE js AS """
  return Object.keys(JSON.parse(input));
""";
{% endmacro %}