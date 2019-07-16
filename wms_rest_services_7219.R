# SEDAC (NASA): https://sedac.ciesin.columbia.edu/data/sets/browse
# GBIF: https://www.gbif.org/en/developer/maps
# RAISG: https://www.amazoniasocioambiental.org/en/maps/#download
# LPDAAC (NASA): https://lpdaacsvc.cr.usgs.gov/ogc/wms
# WDPA (IUCN): http://ec2-54-204-216-109.compute-1.amazonaws.com:6080/arcgis/rest/services/wdpa/wdpa/MapServer

library(leaflet)
library(leaflet.esri)
library(leaflet.extras)
library(rgbif)
library(leaflet.opacity)
library(httr)

urlol <- GET("http://spatial.virtualearth.net/REST/v1/data/7ad4d339605c46c2b9978c69e4298c39/comunidades_cimtar_71519")

leaflet() %>% setView(-71, -2.5, 7) %>% 
  
  #addEsriBasemapLayer(esriBasemapLayers$Oceans, group = "ESRI Oceans") %>% addEsriBasemapLayer(esriBasemapLayers$Imagery, group = "ESRI Imagery") %>% 
  
  addBingTiles(apikey = "Ar2zhWwAE7IwTl1fYHkk5CK9WwjghmlHFz67Dk8kS_f0U_0bcP8z7qFGh52jN-dh",
               imagerySet = c("Aerial"),
               group = "Bing Base",
               options = providerTileOptions(maxZoom = 4, maxNativeZoom = 1)) %>% 
  
  addBingTiles(apikey = "Ar2zhWwAE7IwTl1fYHkk5CK9WwjghmlHFz67Dk8kS_f0U_0bcP8z7qFGh52jN-dh",
               imagerySet = c("AerialWithLabels"),
               group = "Bing Imagery",
               options = providerTileOptions(maxZoom = 4, maxNativeZoom = 1)) %>% 
  
  addEsriFeatureLayer(
    url = paste0("https://geo.socioambiental.org/webadaptor2/rest/services/raisg/raisg_tis/MapServer/3"),
    group = "Indigenous Territories (RAISG)",
    #useServiceSymbology = TRUE,
    labelProperty = 'tis.nombre', labelOptions = labelOptions(textsize = "12px"),
    stroke = TRUE,
    color = "#FF8C00",
    weight = 0.5, 
    fill = TRUE,
    fillOpacity = 0.6,
  ) %>%
  
  addEsriFeatureLayer(
    url = paste0("https://geo.socioambiental.org/webadaptor2/rest/services",
                 "/raisg/raisg_vias/MapServer/0"),
    group = "Roads (RAISG)",
    useServiceSymbology = TRUE,
    labelProperty = 'nombre', labelOptions = labelOptions(textsize = "12px"),
    #stroke = TRUE,
    color = "#FF0000",
    weight = 1.5, 
    #fill = TRUE, 
  ) %>%
  
  addEsriFeatureLayer(
    url = paste0("https://geo.socioambiental.org/webadaptor2/rest/services",
                 "/raisg/raisg_anps/MapServer/6"),
    #url = "http://ec2-54-204-216-109.compute-1.amazonaws.com:6080/arcgis/rest/services/wdpa/wdpa/MapServer/1",
    group = "Protected Areas (RAISG)",
    useServiceSymbology = TRUE,
    labelProperty = 'nombre', labelOptions = labelOptions(textsize = "12px"),
    stroke = TRUE,
    color = "#00FF00",
    weight = 1, 
    opacity = 0.5, 
    fill = TRUE, 
    #fillColor = color,
    fillOpacity = 0.2,
  ) %>%
  
  addEsriFeatureLayer(
    url = "https://geo.socioambiental.org/webadaptor2/rest/services/raisg/raisg_petroleo/MapServer/0",
    group = "Petroleum Blocks (RAISG)",
    color = '#FFA07A',
    weight = 1,
    labelProperty = 'nombre', labelOptions = labelOptions(textsize = "10px"),
  ) %>%
  
  addEsriFeatureLayer(
    url = "https://geo.socioambiental.org/webadaptor2/rest/services/raisg/raisg_mineria/MapServer/0",
    group = "Mining (RAISG)",
    color = '#F542D4',
    weight = 1,
    labelProperty = 'tipo_minerio', labelOptions = labelOptions(textsize = "10px"),
  ) %>%

  #addWMSTiles(
  #  "https://sedac.ciesin.columbia.edu/geoserver/wms",
  #  layers = 'lulc:lulc-development-threat-index',
  #  group = "Development Threat (SEDAC)",
  #  options = WMSTileOptions(format = 'image/png', transparent = TRUE),
  #  attribution = "SEDAC"
  #) %>%
  
  addWMSTiles(
    "https://sedac.ciesin.columbia.edu/geoserver/wms",
    layers = 'gpw-v4:gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-rev11_2020',
    group = "Population Density (SEDAC)",
    options = WMSTileOptions(format = 'image/png', transparent = TRUE),
    attribution = "SEDAC"
  ) %>%
  
  addWMSTiles(
    #"https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@4x.png?srs=EPSG:3857{params}
    #"https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?bin=square&squareSize=128&style=blue.marker",
    #"https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?taxonKey=212&bin=square&squarePerTile=30&style=blue.marker",
    "https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?taxonKey=359&bin=square&squarePerTile=30&style=blue.marker",
    layers = 'gpw-v4:gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-rev11_2020',
    group = "Mammals (GBIF)",
    options = WMSTileOptions(format = 'image/png', transparent = TRUE)
  ) %>%
  
  addWMSTiles(
    #"https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@4x.png?srs=EPSG:3857{params}
    #"https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?bin=square&squareSize=128&style=blue.marker",
    "https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?taxonKey=212&bin=square&squarePerTile=30&style=orange.marker",
    #"https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?taxonKey=359&bin=square&squarePerTile=30&style=orange.marker",
    layers = 'gpw-v4:gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-rev11_2020',
    group = "Birds (GBIF)",
    options = WMSTileOptions(format = 'image/png', transparent = TRUE)
  ) %>%
  
  addWMSTiles(
    "https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?taxonKey=131&bin=hex&hexPerTile=30&style=classic.poly",
    layers = 'gpw-v4:gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-rev11_2020',
    group = "Amphibians (GBIF)",
    options = WMSTileOptions(format = 'image/png', transparent = TRUE)
  ) %>%
  
  addWMSTiles(
    "https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?taxonKey=6&bin=hex&hexPerTile=30&style=green2.poly",
    layers = 'gpw-v4:gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-rev11_2020',
    group = "Plants (GBIF)",
    options = WMSTileOptions(format = 'image/png', transparent = TRUE)
  ) %>%
  
  addWMSTiles(
    baseUrl = "http://spatial.virtualearth.net/REST/v1/data/7ad4d339605c46c2b9978c69e4298c39/comunidades_cimtar_71519/Entity",
    layers = 'comunidades_cimtar_71519',
    group = "Communities"
    #options = WMSTileOptions(format = 'image/png', transparent = TRUE)
  ) %>%
  
  hideGroup("Roads (RAISG)") %>%
  hideGroup("Protected Areas (RAISG)") %>%
  hideGroup("Indigenous Territories (RAISG)") %>%
  hideGroup("Mining (RAISG)") %>%
  hideGroup("Petroleum Blocks (RAISG)") %>%
  hideGroup("Birds (GBIF)") %>%
  hideGroup("Mammals (GBIF)") %>%
  hideGroup("Amphibians (GBIF)") %>%
  hideGroup("Plants (GBIF)") %>%
  
  #addOpacitySlider(layerId = "Population Density (SEDAC)") %>%
  
  addLayersControl(
    overlayGroups = c("Communities", "Protected Areas (RAISG)", "Indigenous Territories (RAISG)", "Mining (RAISG)", "Petroleum Blocks (RAISG)", "Roads (RAISG)", "Birds (GBIF)", "Mammals (GBIF)", "Amphibians (GBIF)", "Plants (GBIF)"),
    baseGroups = c("Bing Imagery", "Population Density (SEDAC)"),#, "Development Threat (SEDAC)"),
    options = layersControlOptions(collapsed = FALSE)
  )
    
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#addEsriFeatureLayer(
#  url = "https://geo.socioambiental.org/webadaptor2/rest/services/raisg/raisg_base/MapServer/1",
#  group = "Cities",
#useServiceSymbology = TRUE,
##  markerType = "circleMarker",
#  weight = 1,
#  color = "#00FF00",
#  stroke = FALSE,
#  fillOpacity = 0.7,
#  labelProperty = 'nomecap', labelOptions = labelOptions(textsize = "10px"),
#) %>%

#  addTiles() %>% addWMSTiles(
#    "https://sedac.ciesin.columbia.edu/geoserver/wms",
#    layers = 'sdei:sdei-trends-freshwater-availability-grace',
#    group = "Freshwater",
#    options = WMSTileOptions(format = 'image/png', transparent = TRUE),
#    attribution = "SEDAC"
#  ) %>%
