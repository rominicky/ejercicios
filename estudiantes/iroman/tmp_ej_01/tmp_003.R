long <- -58.1
lat <- -34.1
mapa <- leaflet()
mapa <- setView(mapa, lng = long, lat = lat, zoom = 12)
mapa <- addTiles(mapa)
mapa
