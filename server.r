
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(NISTunits)
library(geojsonio)
library(rgdal)
source("geo_functions.R")

shinyServer(
  function(input, output, session) {
    points <- eventReactive(input$lat, {
      getBoundingBox(as.numeric(input$lat), as.numeric(input$long), 100)
    }, ignoreNULL = FALSE)
    
    meshBlockIDList <- eventReactive(input$long, {
      GetNearbyMeshBlockIDs(
        as.numeric(input$lat), as.numeric(input$long), 100)
    })
    
    choropleths <- eventReactive(input$dosomething, {
      meshBlockIDList <- GetNearbyMeshBlockIDs(as.numeric(input$lat), as.numeric(input$long), 100)
      
      all_shape_files = c()
    
      for (meshBlockID in meshBlockIDList) {
        shape <- getShapeFile(meshBlockID = strtoi(meshBlockID))
        # spatialPolygon <- readOGR(s, "OGRGeoJSON", verbose=T, disambiguateFIDs = TRUE)
        shape_sp <- readWKT(shape, id=NULL, p4s=NULL)
        
        all_shape_files <- c(all_shape_files,
                             shape_sp)
      }
      #print(all_shape_files)
      all_shape_files
      print(shape_sp)
      shape_sp
      
    })
    
    output$mymap <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$HERE.normalDay,
                         options = providerTileOptions(noWrap = FALSE,
                                                       app_id = "QJT4ednyb3ber0m5g75d",
                                                       app_code = "QplsyvIKvVKCdN3bF8MqPQ")
        ) %>%
        setView(lng = input$long, lat = input$lat, zoom = 12) #%>%
        #addMarkers(data = points())
        #choropleths() %>% addPolygons()
      #%>% addPolygons()
    })
  }
)
