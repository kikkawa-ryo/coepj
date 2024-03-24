{% macro get_preprocess_dict() %}
    {% set preprocess_dict = {
        "unnecessary_descriptions" : [
            {"regexp":"(?i)Recuperando.+nuevo\.", "replacement":""},
            {"regexp":"Similar in profile to No\.1 coffee", "replacement":""},
            {"regexp":"#NAME\?", "replacement":""},
            {"regexp":"\(Brazil fruit\)", "replacement":""},
            {"regexp":"(?i)-\s?like", "replacement":""},
            {"regexp":"very, very sweet!!", "replacement":"very sweet"},
            {"regexp":"n\\/a", "replacement":""},
        ],
        "unsuitable_descriptions" : [
            {"regexp":"Tasted like a Kenya AB", "replacement":""},
            {"regexp":"similar to Kenyans?", "replacement":""},
            {"regexp":"(?i)(Kenyan?|Ethiopia|Gesha|natural)-?(like)?", "replacement":""},
            {"regexp":"richRepresents classic Colombia n profile with richness", "replacement":"rich"},
            {"regexp":"highest score ever for COE Brazil natural coffee", "replacement":""},
            
        ],
        "additional_info" : [
            {"regexp":"(^|\\b)(?i)(\.\s*)?((Aroma(tics)?|Fla(v|o)+r|Aci(c|d)ity|Mouth(\s)*feel|Body|Other|top\sten)\s*(-|:|/|&)+)+", "replacement":""},
            {"regexp":"(^|\\b)(?i)(\.\s*)?(Mouth(\s)*-(\s)*feel)", "replacement":""},
            {"regexp":"(^|\\b)(?i)(\.\s*)?(Body\\/)", "replacement":""},
            {"regexp":"(^|\\b)(?i)(\.\s*)?top ten($|\\b)", "replacement":""},
        ],
        "unnecessary_token" : [
            {"regexp":"[`\[\]]", "replacement":""},
            {"regexp":"\\'(.+)\\'", "replacement":"\\\\1"},
            {"regexp":"\d?\+", "replacement":""},
            {"regexp":"!+", "replacement":""},
            {"regexp":"^(\s|,)+", "replacement":""},
            {"regexp":"(\s|,)+$", "replacement":""},
        ],
        "typo" : [
            {"regexp":"flora \( l9\)", "replacement":"floral (9)"},
            {"regexp":"tight \(9", "replacement":"tight (9)"},
            {"regexp":"V=black cherry", "replacement":"black cherry,"},
            {"regexp":"chocoalte8", "replacement":"chocolate"},
            {"regexp":"pine-y", "replacement":"piney"},
            {"regexp":"grapef\.\.\.", "replacement":"grapefruit"},
            {"regexp":"intense citric w/tartaric", "replacement":"intense citric, tartaric"},
            {"regexp":" f lime", "replacement":"lime"},
            {"regexp":"^v sweet,", "replacement":"lime"}, 
            {"regexp":"C Clean and sweet", "replacement":"Clean and sweet"},
            {"regexp":"peaches, canned", "replacement":"canned peaches"},
            {"regexp":"Watermelon(Citric )?Acid \(4\)", "replacement":"Watermelon, \\\\1Acid (4)"},
            {"regexp":"phosphcitric", "replacement":"phosphoric, citric"},
        ],
        "abbreviation" : [
            {"regexp":"(?i)\\bchoco?(\\b)", "replacement":"chocolate"}
            
        ],
        "hyphen" : [
            {"regexp":"(?i)((stone|tropical) fruit)\s?-", "replacement":""},
            {"regexp":"(?i)(dried|crisp|toasted|extra)s?-", "replacement":"\\\\1"}
        ],
        "irregular" : [
            {"regexp":"strong cinnamon sour\?\?process fruity", "replacement":"strong cinnamon sour process,fruity"},
            {"regexp":"cocoa=late", "replacement":"chocolate"},
            {"regexp":"orange= tart", "replacement":"orange tart"},
            {"regexp":"80% dark chocolate", "replacement":"dark chocolate"},
            {"regexp":"\\bs$", "replacement":""},
            {"regexp":"\\bVa\\b", "replacement":""},
            {"regexp":"black / red currant", "replacement":"black currant, red currant"},
        ],
        "token_to_comma" : [
            {"regexp":"[*]+|/|&", "replacement":","},
            {"regexp":"\s{2,}", "replacement":","}
        ],
        "final" : [
            {"regexp":"^(\s|,)+", "replacement":""},
            {"regexp":"(\s|,)+$", "replacement":""}
        ],
        }
    %}
    {% set preprocess_dict_list = [] %}
    {% for list in preprocess_dict.values() %}
        {{ preprocess_dict_list.extend(list) }}
    {% endfor %}
    {{ return(preprocess_dict_list) }}
{% endmacro %}
