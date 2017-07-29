
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(
  function(input, output, session) {
    
    points <- eventReactive(input$recalc, {
      cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
    
    #leaflet::setView(m_rent,lng=175.5,lat=-37.2,zoom=12)
    #html <- "http://1.aerial.maps.cit.api.here.com/maptile/2.1/maptile/newest/hybrid.day/{z}/{x}/{y}/256/png?app_id=QJT4ednyb3ber0m5g75d&app_code=QplsyvIKvVKCdN3bF8MqPQ&lg=eng"
    #m_rent<-addTiles(m_rent,html)
    
    output$mymap <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$HERE.normalDay,
                         options = providerTileOptions(noWrap = TRUE,
                                                       app_id = "QJT4ednyb3ber0m5g75d",
                                                       app_code = "QplsyvIKvVKCdN3bF8MqPQ")
        ) %>%
        addMarkers(data = points())
    })
  }
)
