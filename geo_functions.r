library(httr)
library(xml2)
library(jsonlite)
library(wellknown)
library(rangeMapper)
library(RMySQL)
library(sp)
# Functions to calculate bounding boxes and other stuff

getBoundingBox <- function(latitude, longitude, distance) {
  lat <- NISTdegTOradian(latitude)
  long <- NISTdegTOradian(longitude)
  halfSide <- 1000*distance
  
  radius <- WGS84EarthRadius(latitude)
  pradius <- radius*cos(longitude)
  
  latMin <- NISTradianTOdeg(lat - halfSide/radius)
  latMax <- NISTradianTOdeg(lat + halfSide/radius)
  longMin <- NISTradianTOdeg(long - halfSide/pradius)
  longMax <- NISTradianTOdeg(long + halfSide/pradius)
  
  coords <- cbind(c(latMin, latMin, latMax, latMax),
                  c(longMin, longMax, longMin, longMax))
  colnames(coords) <- c("lat", "long")
  
  print(coords)
  
  return(coords)
}

WGS84EarthRadius <- function(lat) {
  WGS84_a <- 6378137.0
  WGS84_b <- 6356752.3
  An <- WGS84_a*WGS84_a * cos(lat)
  Bn <- WGS84_b*WGS84_b * sin(lat)
  Ad <- WGS84_a * cos(lat)
  Bd <- WGS84_b * sin(lat)
  
  return(sqrt((An*An + Bn*Bn)/(Ad*Ad + Bd*Bd)))
}

########################### HTTP request function ##############################
GetNearbyMeshBlockIDs <- function(lat, long, distance) {
  app_id <- 'QJT4ednyb3ber0m5g75d'
  app_code <- 'QplsyvIKvVKCdN3bF8MqPQ'
  layer_ids <- '1'
  # proximity <- c(lat, long, distance)
  proximity <- sprintf("%f,%f,%f", lat, long, distance)
  
  query = list(app_id='QJT4ednyb3ber0m5g75d',
               app_code='QplsyvIKvVKCdN3bF8MqPQ',
               layer_ids='1',
               proximity=proximity)
  
  # Do GET request
  url <- "https://cle.cit.api.here.com/2/search/proximity.json"
  
  request <- GET(url=url, query = query)
  response <- fromJSON((content(request, "text")))
  return(subset(response$geometries$attributes, select=c("MB2017")))
}

getShapeFile <- function(meshBlockID) {
  sprintf("Getting shape file for %i", meshBlockID)
  # Gets a shape file from the local DB and turns it into GeoJSON
  con <- dbConnect(MySQL(),
                   user="govhack2017", password="govhack2017",
                   dbname="WanderSafe", host="localhost")
  # Prone to SQL injection - I know, and I'm too time-constrained to care
  sql <- sprintf("SELECT * FROM MeshBlocks where id=%i", meshBlockID);
  results <- dbGetQuery(con, sql);
  on.exit(dbDisconnect(con));
  return(results$shapefile)
  #print(st_as_sfc(results$shapefile))
  #return(st_as_sfc(toString(results$shapefile)))
  # return(wkt2geojson(results$shapefile))
}

spToGeoJSON <- function(x){
  # Return sp spatial object as geojson by writing a temporary file.
  # It seems the only way to convert sp objects to geojson is 
  # to write a file with OGCGeoJSON driver and read the file back in.
  # The R process must be allowed to write and delete temporoary files.
  #tf<-tempfile('tmp',fileext = '.geojson')
  tf<-tempfile()
  writeOGR(x, tf,layer = "geojson", driver = "GeoJSON")
  js <- paste(readLines(tf), collapse=" ")
  file.remove(tf)
  return(js)
}
