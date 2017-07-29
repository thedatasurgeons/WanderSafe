
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(
  function(input, output, session) {
    
    location <- eventReactive(input$submitLocation, {
      c(input$lat, input$long)
    }, ignoreNULL = FALSE)
    
    lat_from_client <- renderPrint({input$lat})
    lng_from_client <- renderPrint({input$long})
    
    output$mymap <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$HERE.normalDay,
                         options = providerTileOptions(noWrap = FALSE,
                                                       app_id = "QJT4ednyb3ber0m5g75d",
                                                       app_code = "QplsyvIKvVKCdN3bF8MqPQ")
        ) %>%
        setView(lng = input$long, lat = input$lat, zoom = 12)
    })
  }
)
