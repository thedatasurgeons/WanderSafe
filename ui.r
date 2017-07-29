
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)


shinyUI(
  fluidPage(
    tags$script('$(document).ready(function () {
                  navigator.geolocation.getCurrentPosition(onSuccess, onError);
                
                  function onError (err) {
                    Shiny.onInputChange("geolocation", false);
                  }
                
                  function onSuccess (position) {
                    setTimeout(function () {
                      var coords = position.coords;
                      console.log(coords.latitude + ", " + coords.longitude);
                      Shiny.onInputChange("geolocation", true);
                      Shiny.onInputChange("lat", coords.latitude);
                      Shiny.onInputChange("long", coords.longitude);
                      }, 1100)
                    }
                  });
                '),
    titlePanel("WanderSafe - by The Data Surgeons"),
    leafletOutput("mymap"),
    p(),
    textInput("lat", "latitude", value = "-37.23"),
    textInput("long", "longitude", value = "175.5"),
    actionButton("submitLocation", "Submit location")
  )
)
