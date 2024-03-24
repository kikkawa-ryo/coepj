{% macro get_process_dict() %}
    {% set process_dict = {
        "unnecessary_token" : [
            {"regexp":"^[,-]", "replacement":""},
            {"regexp":"[,-]$", "replacement":""},
            {"regexp":"(^|\\b)\s*\\\"\s*", "replacement":""},
            {"regexp":"\s*\\\"\s*($|\\b)", "replacement":""},
        ],
        "parentheses" : [
            {"regexp":'(.*?)\s*\((.+)\)\s*(.*?)', "replacement":'\\\\1,\\\\2,\\\\3'}
        ],
        "typo" : [
            {"regexp":"(?i)(\\b)ascetic(\\b)", "replacement":"acetic"},
            {"regexp":"(?i)(\\b)(acit)(\\b)", "replacement":"acid"},
            {"regexp":"(?i)(\\b)(acidid)(\\b)", "replacement":"acidic"},
            {"regexp":"(?i)(\\b)(acidit|acicidity)(\\b)", "replacement":"acidity"},
            {"regexp":"(?i)(\\b)(aftertatse|aftertast|aftertasre|atftertaste|aftertasrte|aftertase|afterstaste)(\\b)", "replacement":"aftertaste"},
            {"regexp":"(?i)(\\b)atteibutes(\\b)", "replacement":"attributes"},
            {"regexp":"(?i)(\\b)(aprico|apriocot|aprciot)(\\b)", "replacement":"apricot"},
            {"regexp":"(?i)(\\b)asaam(\\b)", "replacement":"assam"},
            {"regexp":"(?i)(\\b)ballanced(\\b)", "replacement":"balanced"},
            {"regexp":"(?i)(\\b)barbueue(\\b)", "replacement":"barbecue"},
            {"regexp":"(?i)(\\b)berr(\\b)", "replacement":"berry"},
            {"regexp":"(?i)(\\b)beries(\\b)", "replacement":"berries"},
            {"regexp":"(?i)(\\b)(bergamont|bourgemot|vergamot|bergomot|bergamott)(\\b)", "replacement":"bergamot"},
            {"regexp":"(?i)(\\b)(backberry|lackbeerry)(\\b)", "replacement":"blackberry"},
            {"regexp":"(?i)(\\b)blackcurrent(\\b)", "replacement":"blackcurrant"},
            {"regexp":"(?i)(\\b)(bluberry|bluberry)(\\b)", "replacement":"blueberry"},
            {"regexp":"(?i)(\\b)(bight|birght|blight)(\\b)", "replacement":"bright"},
            {"regexp":"(?i)(\\b)brwon(\\b)", "replacement":"brown"},
            {"regexp":"(?i)(\\b)batter(\\b)", "replacement":"butter"},
            {"regexp":"(?i)(\\b)butterscoth(\\b)", "replacement":"butterscotch"},
            {"regexp":"(?i)(\\b)(cacau|cocao|cacaco)(\\b)", "replacement":"cacao"},
            {"regexp":"(?i)(\\b)(can|cain)(\\b)", "replacement":"cane"},
            {"regexp":"(?i)(\\b)cand(\\b)", "replacement":"candy"},
            {"regexp":"(?i)(\\b)candis(\\b)", "replacement":"candies"},
            {"regexp":"(?i)(\\b)(canteloupel|cantelope|canteloupe)(\\b)", "replacement":"cantaloupe"},
            {"regexp":"(?i)(\\b)(cardomom|caradamom|cardamon)(\\b)", "replacement":"cardamom"},
            {"regexp":"(?i)(\\b)caramely(\\b)", "replacement":"caramelly"},
            {"regexp":"(?i)(\\b)caramelied(\\b)", "replacement":"caramelized"},
            {"regexp":"(?i)(\\b)cascarra(\\b)", "replacement":"cascara"},
            {"regexp":"(?i)(\\b)(casisi|cassias|casisu)(\\b)", "replacement":"casis"},
            {"regexp":"(?i)(\\b)(chammile|camomile)(\\b)", "replacement":"chamomile"},
            {"regexp":"(?i)(\\b)(chcolate|cholocate|chcocolate|choclate|chcocalte|choclotae|chocoalte|chcoalte|choclolate|chocolatet|chocolat)(\\b)", "replacement":"chocolate"},
            {"regexp":"(?i)(\\b)chocolaty(\\b)", "replacement":"chocolatey"},
            {"regexp":"(?i)(\\b)cidar(\\b)", "replacement":"cider"},
            {"regexp":"(?i)(\\b)(cereamy|creamt)(\\b)", "replacement":"creamy"},
            {"regexp":"(?i)(\\b)compeling(\\b)", "replacement":"compelling"},
            {"regexp":"(?i)(\\b)(consistant|consitent)(\\b)", "replacement":"consistent"},
            {"regexp":"(?i)(\\b)consistence(\\b)", "replacement":"consistance"},
            {"regexp":"(?i)(\\b)(cacoa|cooca)(\\b)", "replacement":"cocoa"},
            {"regexp":"(?i)(\\b)crysanthemum(\\b)", "replacement":"chrysanthemum"},
            {"regexp":"(?i)(\\b)(cinimmon|cinnoman|cinamon|cinammon)(\\b)", "replacement":"cinnamon"},
            {"regexp":"(?i)(\\b)(ciric|ctric|citiric|critic|cirtic|citirc|citrica|citrico)(\\b)", "replacement":"citric"},
            {"regexp":"(?i)(\\b)(citus|critus|citris)(\\b)", "replacement":"citrus"},
            {"regexp":"(?i)(\\b)(coco|cocoanut)(\\b)", "replacement":"coconut"},
            {"regexp":"(?i)(\\b)conicac(\\b)", "replacement":"cognac"},
            {"regexp":"(?i)(\\b)(caomplex|complx|complexy|compplex|complext|coomplex|copmlex)(\\b)", "replacement":"complex"},
            {"regexp":"(?i)(\\b)crusp(\\b)", "replacement":"crisp"},
            {"regexp":"(?i)(\\b)(carnberry|cramberry)(\\b)", "replacement":"cranberry"},
            {"regexp":"(?i)(\\b)(cureant|currat|current|carrunt)(\\b)", "replacement":"currant"},
            {"regexp":"(?i)(\\b)currents(\\b)", "replacement":"currants"},
            {"regexp":"(?i)(\\b)desert(\\b)", "replacement":"dessert"},
            {"regexp":"(?i)dimention(\\b)", "replacement":"dimension"},
            {"regexp":"(?i)dimentional(\\b)", "replacement":"dimensional"},
            {"regexp":"(?i)(\\b)dinamic(\\b)", "replacement":"dynamic"},
            {"regexp":"(?i)(\\b)(efersvescent|efervesant|effervescente|efervesent)(\\b)", "replacement":"effervescent"},
            {"regexp":"(?i)(\\b)effevesence(\\b)", "replacement":"effervescence"},
            {"regexp":"(?i)(\\b)essentual(\\b)", "replacement":"essential"},
            {"regexp":"(?i)(\\b)exapnding(\\b)", "replacement":"expanding"},
            {"regexp":"(?i)(\\b)bruit(\\b)", "replacement":"fruit"},
            {"regexp":'(?i)(\\b)(flora|loral|florall|florar)(\\b)', "replacement":'floral'},
            {"regexp":'(?i)(\\b)forrest(\\b)', "replacement":'forest'},
            {"regexp":'(?i)(\\b)fiji(\\b)', "replacement":'fuji'},
            {"regexp":"(?i)(\\b)finsih(\\b)", "replacement":"finish"},
            {"regexp":"(?i)(\\b)ginceng(\\b)", "replacement":"ginseng"},
            {"regexp":"(?i)(\\b)goosberry(\\b)", "replacement":"gooseberry"},
            {"regexp":"(?i)(\\b)grandaillia(\\b)", "replacement":"granadilla"},
            {"regexp":"(?i)(\\b)garpe(\\b)", "replacement":"grape"},
            {"regexp":"(?i)(\\b)gripes(\\b)", "replacement":"grapes"},
            {"regexp":"(?i)(\\b)(grapfruit|grapefuit|grapfruitfruit)(\\b)", "replacement":"grapefruit"},
            {"regexp":"(?i)(\\b)(reen|geen)(\\b)", "replacement":"green"},
            {"regexp":"(?i)(\\b)(guave|guawa|quava)(\\b)", "replacement":"guava"},
            {"regexp":"(?i)(\\b)harb(\\b)", "replacement":"herb"},
            {"regexp":"(?i)(\\b)(harmonius|hormonious)(\\b)", "replacement":"harmonious"},
            {"regexp":"(?i)(\\b)heavry(\\b)", "replacement":"heavy"},
            {"regexp":"(?i)(\\b)(hone|hoeny)(\\b)", "replacement":"honey"},
            {"regexp":"(?i)(\\b)honeycrsip(\\b)", "replacement":"honeycrisp"},
            {"regexp":"(?i)(\\b)hibiscous(\\b)", "replacement":"hibiscus"},
            {"regexp":"(?i)(\\b)hige(\\b)", "replacement":"huge"},
            {"regexp":"(?i)(\\b)intence(\\b)", "replacement":"intense"},
            {"regexp":"(?i)(\\b)jabojocaba(\\b)", "replacement":"jabuticaba"},
            {"regexp":"(?i)(\\b)jackfuit(\\b)", "replacement":"jackfruit"},
            {"regexp":"(?i)(\\b)jamica(\\b)", "replacement":"jamaica"},
            {"regexp":"(?i)(\\b)(jazimin|jasomine|ijasmine|jazmin)(\\b)", "replacement":"jasmine"},
            {"regexp":"(?i)(\\b)jucie(\\b)", "replacement":"juice"},
            {"regexp":"(?i)(\\b)(uicy|jucy)(\\b)", "replacement":"juicy"},
            {"regexp":"(?i)(\\b)(kumcuat|cumquat)(\\b)", "replacement":"kumquat"},
            {"regexp":"(?i)(\\b)keffir(\\b)", "replacement":"kefir"},
            {"regexp":"(?i)(\\b)lactica(\\b)", "replacement":"lactic"},
            {"regexp":"(?i)(\\b)(levander|lavendar)(\\b)", "replacement":"lavender"},
            {"regexp":"(?i)(\\b)(lemn|tlemon)(\\b)", "replacement":"lemon"},
            {"regexp":"(?i)(\\b)lemonglass(\\b)", "replacement":"lemongrass"},
            {"regexp":"(?i)(\\b)lilly(\\b)", "replacement":"lily"},
            {"regexp":"(?i)(\\b)(limey|line)(\\b)", "replacement":"lime"},
            {"regexp":"(?i)(\\b)limonatta(\\b)", "replacement":"limonata"},
            {"regexp":"(?i)(\\b)(lingeing|ligering)(\\b)", "replacement":"lingering"},
            {"regexp":"(?i)(\\b)(liquorr|liquare|liquour|liqour|liquer)(\\b)", "replacement":"liquor"},
            {"regexp":"(?i)(\\b)macha(\\b)", "replacement":"matcha"},
            {"regexp":"(?i)(\\b)(mailc|malik|malice|mallic)(\\b)", "replacement":"malic"},
            {"regexp":"(?i)(\\b)malta(\\b)", "replacement":"malt"},
            {"regexp":"(?i)(\\b)(mandrine|mandalin|mandarina|mandarine)(\\b)", "replacement":"mandarin"},
            {"regexp":"(?i)(\\b)(mamgo|nango)(\\b)", "replacement":"mango"},
            {"regexp":"(?i)(\\b)marischino(\\b)", "replacement":"maraschino"},
            {"regexp":"(?i)(\\b)marshmellow(\\b)", "replacement":"marshmallow"},
            {"regexp":"(?i)(\\b)marmelade(\\b)", "replacement":"marmalade"},
            {"regexp":"(?i)(\\b)(marzepan|marzapam)(\\b)", "replacement":"marzipan"},
            {"regexp":"(?i)(\\b)mejdool(\\b)", "replacement":"medjool"},
            {"regexp":"(?i)(\\b)marangue(\\b)", "replacement":"meringue"},
            {"regexp":"(?i)(\\b)mik(\\b)", "replacement":"milk"},
            {"regexp":"(?i)(\\b)montainberry(\\b)", "replacement":"mountainberry"},
            {"regexp":"(?i)(\\b)mouthdeel(\\b)", "replacement":"mouthfeel"},
            {"regexp":"(?i)(\\b)mutiple(\\b)", "replacement":"multiple"},
            {"regexp":"(?i)(\\b)(muscato|muscot|mascut|masucat)(\\b)", "replacement":"muscat"},
            {"regexp":"(?i)(\\b)muscatine(\\b)", "replacement":"muscadine"},
            {"regexp":"(?i)(\\b)muscavado(\\b)", "replacement":"muscovado"},
            {"regexp":"(?i)(\\b)naval(\\b)", "replacement":"navel"},
            {"regexp":"(?i)(\\b)(necatrine|necatarine)(\\b)", "replacement":"nectarine"},
            {"regexp":"(?i)(\\b)(nouget|nugat)(\\b)", "replacement":"nougat"},
            {"regexp":"(?i)(\\b)nnut(\\b)", "replacement":"nut"},
            {"regexp":"(?i)(\\b)(orane|orang|ornge|oragne|ornage)(\\b)", "replacement":"orange"},
            {"regexp":"(?i)(\\b)panetone(\\b)", "replacement":"panettone"},
            {"regexp":"(?i)(\\b)(panellla|panelle)(\\b)", "replacement":"panella"},
            {"regexp":"(?i)(\\b)payaay(\\b)", "replacement":"papaya"},
            {"regexp":"(?i)(\\b)pasion(\\b)", "replacement":"passion"},
            {"regexp":"(?i)(\\b)pasionfruit(\\b)", "replacement":"passionfruit"},
            {"regexp":"(?i)(\\b)(each|pech|peacy)(\\b)", "replacement":"peach"},
            {"regexp":"(?i)(\\b)pearl(\\b)", "replacement":"pear"},
            {"regexp":"(?i)(\\b)peal(\\b)", "replacement":"peel"},
            {"regexp":"(?i)(\\b)peeper(\\b)", "replacement":"pepper"},
            {"regexp":"(?i)(\\b)persimon(\\b)", "replacement":"persimmon"},
            {"regexp":"(?i)(\\b)(phospho|phosforic)(\\b)", "replacement":"phosphoric"},
            {"regexp":"(?i)(\\b)plesant(\\b)", "replacement":"pleasant"},
            {"regexp":"(?i)(\\b)plumb(\\b)", "replacement":"plum"},
            {"regexp":"(?i)(\\b)(pineple|pinealpple|pinneappl|pineaple|pinaablne)(\\b)", "replacement":"pineapple"},
            {"regexp":"(?i)(\\b)(pomgreanate|pomengranate|omegranate|pommegranate)(\\b)", "replacement":"pomegranate"},
            {"regexp":"(?i)(\\b)pamelo(\\b)", "replacement":"pomelo"},
            {"regexp":"(?i)(\\b)(aisin|rasin|rasisin|raison)(\\b)", "replacement":"raisin"},
            {"regexp":"(?i)(\\b)(rasins|raisons)(\\b)", "replacement":"raisins"},
            {"regexp":"(?i)(\\b)(raspbery|rasperry|raseberry|rasberry)(\\b)", "replacement":"raspberry"},
            {"regexp":"(?i)(\\b)refresing(\\b)", "replacement":"refreshing"},
            {"regexp":"(?i)(\\b)(roibioos|roobois)(\\b)", "replacement":"rooibos"},
            {"regexp":"(?i)(\\b)arose(\\b)", "replacement":"rose"},
            {"regexp":"(?i)(\\b)rosemerry(\\b)", "replacement":"rosemary"},
            {"regexp":"(?i)(\\b)roesewater(\\b)", "replacement":"rosewater"},
            {"regexp":"(?i)(\\b)rosted(\\b)", "replacement":"roasted"},
            {"regexp":"(?i)(\\b)suage(\\b)", "replacement":"sage"},
            {"regexp":"(?i)(\\b)(sandlewood|sandalewood)(\\b)", "replacement":"sandalwood"},
            {"regexp":"(?i)(\\b)sasparilla(\\b)", "replacement":"sarsaparilla"},
            {"regexp":"(?i)(\\b)seseme(\\b)", "replacement":"sesame"},
            {"regexp":"(?i)(\\b)shinny(\\b)", "replacement":"shiny"},
            {"regexp":"(?i)(\\b)(smoot|smootj)(\\b)", "replacement":"smooth"},
            {"regexp":"(?i)(\\b)scour(\\b)", "replacement":"sour"},
            {"regexp":"(?i)(\\b)sparkley(\\b)", "replacement":"sparkly"},
            {"regexp":"(?i)(\\b)(straberry|strawaberry)(\\b)", "replacement":"strawberry"},
            {"regexp":"(?i)(\\b)(structired|strutured|sturctured|structred|strucutred)(\\b)", "replacement":"structured"},
            {"regexp":"(?i)(\\b)strcture(\\b)", "replacement":"structure"},
            {"regexp":"(?i)(\\b)struedel(\\b)", "replacement":"strudel"},
            {"regexp":"(?i)(\\b)(sillky|silkly)(\\b)", "replacement":"silky"},
            {"regexp":"(?i)(\\b)spicey(\\b)", "replacement":"spicy"},
            {"regexp":"(?i)(\\b)(spakling|sparling)(\\b)", "replacement":"sparkling"},
            {"regexp":"(?i)(\\b)(sugarcan|sugercane)(\\b)", "replacement":"sugarcane"},
            {"regexp":"(?i)(\\b)suga(\\b)", "replacement":"sugar"},
            {"regexp":"(?i)(\\b)sultan(\\b)", "replacement":"sultana"},
            {"regexp":"(?i)(\\b)seeet(\\b)", "replacement":"sweet"},
            {"regexp":"(?i)(\\b)sirup(\\b)", "replacement":"syrup"},
            {"regexp":"(?i)(\\b)sirupy(\\b)", "replacement":"syrupy"},
            {"regexp":"(?i)(\\b)(tamarinde|tamarindo)(\\b)", "replacement":"tamarind"},
            {"regexp":"(?i)(\\b)tangarine(\\b)", "replacement":"tangerine"},
            {"regexp":"(?i)(\\b)(tartarric|tarataric|tartarc|tatarlic|tartari|tartic|tataric|tartartic|tartric|tartanic|tartalic)(\\b)", "replacement":"tartaric"},
            {"regexp":"(?i)(\\b)(obacco|tabaco)(\\b)", "replacement":"tobacco"},
            {"regexp":"(?i)(\\b)toffy(\\b)", "replacement":"toffee"},
            {"regexp":"(?i)(\\b)(tranceparent|trasparent)(\\b)", "replacement":"transparent"},
            {"regexp":"(?i)(\\b)(topical|tropical|tropicial|troicpal|tropcial|trapical)(\\b)", "replacement":"tropical"},
            {"regexp":"(?i)(\\b)tricale(\\b)", "replacement":"triticale"},
            {"regexp":"(?i)(\\b)turbanado(\\b)", "replacement":"turbinado"},
            {"regexp":"(?i)(\\b)unami(\\b)", "replacement":"umami"},
            {"regexp":"(?i)(\\b)vainilla(\\b)", "replacement":"vanilla"},
            {"regexp":"(?i)(\\b)velvetty(\\b)", "replacement":"velvety"},
            {"regexp":"(?i)(\\b)verbana(\\b)", "replacement":"verbena"},
            {"regexp":"(?i)(\\b)(vicious|vicscous|viscuous|viscus|viscious|viscose)(\\b)", "replacement":"viscous"},
            {"regexp":"(?i)(\\b)viscocity(\\b)", "replacement":"viscosity"},
            {"regexp":"(?i)(\\b)atermelon(\\b)", "replacement":"watermelon"},
            {"regexp":"(?i)(\\b)whit(\\b)", "replacement":"white"},
            {"regexp":"(?i)(\\b)tyellow(\\b)", "replacement":"yellow"},
            {"regexp":"(?i)(\\b)yougurt(\\b)", "replacement":"yogurt"},
        ],
        "extend" : [
            {"regexp":"(?i)(^)rasp($)", "replacement":"raspberry"},
            {"regexp":"(?i)(^)stone($)", "replacement":"stone fruit"},
        ],
        "hyphen" : [
            {"memo":"２単語で成立","conditions": [{"type": "contains", "pattern": "(?i)(pinot-noir|strawberry-yogurt|black-cherry|rose-hip|coconut-caramel|green-apple|Christmas-cherry|tutti-frutti|blood-orange|cherry-vanilla|mint-chocolate|coca-cola|chocolate-banana|orange-chocolate|honey-lemon|rose-tea|chocolate ice-cream|chocolate-covered berry)"}],  "regexp":"-", "replacement":' '},
            {"memo":"繋げても成立","conditions": [{"type": "contains", "pattern": "(?i)(multi-dimensional|cinnamon-sugar|stone-fruits?||honey-suckle|lemon-grass|butter-scotch)"}],  "regexp":"-", "replacement":' '},
            {"memo":"形容詞-副詞混じり","conditions": [{"type": "contains", "pattern": "(?i)(semi-sweet|Sweet-herb|sweet-savory|sweet-ginger)"}],  "regexp":"-", "replacement":' '},
            {"memo":"分割","conditions": [{"type": "contains", "pattern": "(?i)(toffee-fudge|winey-floral|licorice-anise|strawberry-rhubarb|lemon-mandarin|Cherry-floral|Rasberry-Floral|citrus-Redcurrant|tangerine-citrus|apple-orange|cinnamon-spicy|apricot-sweetness|chocolate-Creamy|lemon-lime|chocolate-orange|lemon-honey)"}],  "regexp":"-", "replacement":','},
            {"memo":"説明-名称","regexp":'(Ripe Red fruits|Dried red fruits|sweet spice)-(apple|peach|clove)', "replacement":'\\\\2'},
            {"memo":"具体-カテゴリ","regexp":'(?i)(lime|paprika)-(citrus|spice)', "replacement":'\\\\1'},
            {"memo":"具体-カテゴリ","regexp":'(?i)(citrus)-(lime)', "replacement":'\\\\2'},

            {"regexp":'warm-tropical fruit', "replacement":'tropical fruit'},
            {"regexp":'red grape-mellowed to peach', "replacement":'red grape,peach'},
            {"regexp":'vanilla-peach combination mandarin orange', "replacement":'vanilla,peach,mandarin orange'},
            {"regexp":'honey green tea -rose dried fruit', "replacement":'honey,green tea,rose,dried fruit'},
        ],
        "of" : [
            {"regexp":'(?i)((lily of the valley)|(.*?)(underlying|little|with a)?\s?((layer|hint|note|touch|little drop|a?\s?lot)s?\sof\s)(.*))', "replacement":'\\\\2\\\\3,\\\\7'}
        ],
        "in" : [
            {"regexp":'(?i)\s?\\bin\\b.+(finish|aftertaste|aroma|finish|spades|mouth|cup|flavor|beginning|fragrance|way)\s?', "replacement":','}
        ],
        "on" : [
            {"regexp":'(?i)\s?\\bon\\b.+(aroma|finish)\s?', "replacement":','}
        ],
        "note" : [
            {"regexp":'(?i)\s?notes?\s?', "replacement":','}
        ],

        "unnecessary" : [
            {"regexp":'\\bcom\\b', "replacement":''}
        ],
        "and" : [
            {"regexp":'^and\s', "replacement":''},
            {"memo":"and1_blank2","conditions": [{"type": "contains", "pattern": " and "}, {"type": "count", "pattern": " ", "sign": "=", "n": 2}], "regexp":'\sand\s', "replacement":','},
            
        ],
        "final" : [
            {"regexp":'^(\s|,)+', "replacement":''},
            {"regexp":'(\s|,)+$', "replacement":''}
        ],
        }
    %}
    {% set process_dict_list = [] %}
    {% for list in process_dict.values() %}
        {{ process_dict_list.extend(list) }}
    {% endfor %}
    {{ return(process_dict_list) }}
{% endmacro %}
