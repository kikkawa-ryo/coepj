{% macro get_translate_dict() %}
    {% set translate_dict = {
        "paraphrase" : [
            {"regexp":'(?i)(\\b)cassis(\\b)', "replacement":'blackcurrant'}
        ],
        "typo" : [
            {"regexp":'(?i)(\\b)guananava(\\b)', "replacement":'guava'},
            {"regexp":'(?i)(\\b)muscavor(\\b)', "replacement":'muscavado'},
            {"regexp":'(?i)(\\b)toff(\\b)', "replacement":'toffee'},
            {"regexp":'(?i)(\\b)pastcochio(\\b)', "replacement":'pastichio'}
        ],
        "product_name" : [
            {"regexp":'(?i)(\\b)bala(\\b)', "replacement":'butter toffee'}
        ],
        "other" : [
            {"regexp":'(?i)(\\b)uvaia(\\b)', "replacement":'eugenia pyriformis'}
        ],
        "spanish" : [
            {"regexp":'(?i)(\\b)ron con pasas(\\b)', "replacement":'rum raisin'},
            {"regexp":'(?i)(\\b)te verde(\\b)', "replacement":'green tea'},
            {"regexp":'(?i)(\\b)acidez de cascara de naranja(\\b)', "replacement":'Orange peel acidity'},

            {"regexp":'(?i)(\\b)acidez(\\b)', "replacement":'acidity'},
            {"regexp":'(?i)(\\b)acaramelado(\\b)', "replacement":'caramel'},
            {"regexp":'(?i)(\\b)apanelado(\\b)', "replacement":'honeycomb'},
            {"regexp":'(?i)(\\b)avellanas(\\b)', "replacement":'hazelnut'},
            {"regexp":'(?i)(\\b)(almendra|Almeida)(\\b)', "replacement":'almond'},
            {"regexp":'(?i)(\\b)balanceado(\\b)', "replacement":'balanced'},
            {"regexp":'(?i)(\\b)bajo(\\b)', "replacement":''},
            {"regexp":'(?i)(\\b)bayas(\\b)', "replacement":'berry'},
            {"regexp":'(?i)(\\b)cana(\\b)', "replacement":'cane'},
            {"regexp":'(?i)(\\b)canela(\\b)', "replacement":'cinnamon'},
            {"regexp":'(?i)(\\b)(caramello|carmela|caramac|carmelo|carmello|caramelo)(\\b)', "replacement":'caramel'},
            {"regexp":'(?i)(\\b)(cedro|ceder)(\\b)', "replacement":'cedar'},
            {"regexp":'(?i)(\\b)cereza(\\b)', "replacement":'cherry'},
            {"regexp":'(?i)(\\b)cerezas(\\b)', "replacement":'cherries'},
            {"regexp":'(?i)(\\b)(dulce|dulcet)(\\b)', "replacement":'sweet'},
            {"regexp":'(?i)(\\b)durazno(\\b)', "replacement":'peach'},
            {"regexp":'(?i)(\\b)especiado(\\b)', "replacement":'spicy'},
            {"regexp":'(?i)(\\b)fragante(\\b)', "replacement":'fragrant'},
            {"regexp":'(?i)(\\b)flor(\\b)', "replacement":'flower'},
            {"regexp":'(?i)(\\b)fresa(\\b)', "replacement":'strawberry'},
            {"regexp":'(?i)(\\b)frutal(\\b)', "replacement":'fruital'},
            {"regexp":'(?i)(\\b)frutas(\\b)', "replacement":'fruits'},
            {"regexp":'(?i)(\\b)(grosella|groselia)(\\b)', "replacement":'red currant'},
            {"regexp":'(?i)(\\b)guayaba(\\b)', "replacement":'guava'},
            {"regexp":'(?i)(\\b)(guanabana|guyabana)(\\b)', "replacement":'soursop'},
            {"regexp":'(?i)(\\b)jarabe(\\b)', "replacement":'syrup'},
            {"regexp":'(?i)(\\b)lima(\\b)', "replacement":'lime'},
            {"regexp":'(?i)(\\b)limon(\\b)', "replacement":'lemon'},
            {"regexp":'(?i)(\\b)licha(\\b)', "replacement":'lychee'},
            {"regexp":'(?i)(\\b)(malica|malico)(\\b)', "replacement":'malic'},
            {"regexp":'(?i)(\\b)melocoton(\\b)', "replacement":'peach'},
            {"regexp":'(?i)(\\b)melaco(\\b)', "replacement":'molasses'},
            {"regexp":'(?i)(\\b)menta(\\b)', "replacement":'mint'},
            {"regexp":'(?i)(\\b)mora( azul)?(\\b)', "replacement":'blue berry'},
            {"regexp":'(?i)(\\b)naranja(\\b)', "replacement":'orange'},
            {"regexp":'(?i)(\\b)pasa(\\b)', "replacement":'raisin'},
            {"regexp":'(?i)(\\b)sostenido(\\b)', "replacement":'sustained'},
            {"regexp":'(?i)(\\b)tropicales(\\b)', "replacement":'tropical'},
            {"regexp":'(?i)(\\b)uva(\\b)', "replacement":'grape'}
        ],
        "latina" : [
            {"regexp":'(?i)(\\b)mel(\\b)', "replacement":'honey'}
        ],
        "portuguese" : [
            {"regexp":'(?i)(\\b)leite(\\b)', "replacement":'milk'},
            {"regexp":'(?i)(\\b)melao(\\b)', "replacement":'melon'},
            {"regexp":'(?i)(\\b)mascavo(\\b)', "replacement":'muscovado'},
            {"regexp":'(?i)(\\b)ibisco(\\b)', "replacement":'hibiscus'},
            {"regexp":'(?i)(\\b)pessego(\\b)', "replacement":'peach'}
        ],
        "french" : [
            {"regexp":'(?i)(\\b)brule(\\b)', "replacement":'brulee'},
            {"regexp":'(?i)(\\b)creme(\\b)', "replacement":'cream'},
            {"regexp":'(?i)(\\b)miel(\\b)', "replacement":'honey'},
        ],
        "italian" : [
            {"regexp":'(?i)(\\b)concorde(\\b)', "replacement":'concord'},
            {"regexp":'(?i)(\\b)dolce(\\b)', "replacement":'sweet'},
            {"regexp":'(?i)(\\b)leche(\\b)', "replacement":'milk'}
        ]
        }
    %}
    {% set translate_dict_list = [] %}
    {% for list in translate_dict.values() %}
        {{ translate_dict_list.extend(list) }}
    {% endfor %}
    {{ return(translate_dict_list) }}
{% endmacro %}