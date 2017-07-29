
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)

shinyUI(
  fluidPage(
    leafletOutput("mymap"),
    p(),
    textInput("lat", "latitude", value = "-37.23"),
    textInput("long", "longitude", value = "175.5"),
    actionButton("submitLocation", "Submit location")
  )
)
