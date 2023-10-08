import geocoder
# place = 'Takesi, Yanacahi, Yungas , La Paz, Bolivia'
# place = 'Yanacahi La Paz Bolivia'
# place = 'Chapada Diamantina, Brasil, Livramento de Nossa Senhora, Bahía, Brasil'
place = 'Matas, Minas, Brazil'
key = 'pk.eyJ1Ijoia2lra2F3YSIsImEiOiJjbGtkcWl0NWkweGZuM3FxZjNjNmRvajc4In0.8CiYACpL5X_gPr8HYNhOFQ'
g = geocoder.mapbox(place, country='BR', maxRows=7, key=key)
for r in g:
    print(r.address, r.country, r.latlng, r.lat, r.lng)
