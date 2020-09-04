#' Checks the avialability and validity of ZIP's
#' @description
#' This function uses system calls of \code{unzip -t} to check the validity of
#' zip archives
#'
#' @param x \code{character}, vector with full path/filename.zip.
#'
#' @return
#' \code{logical vector} with \code{TRUE} if a zip archive exists & is not corrupt
#' according to \code{unzip -t} call.
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @export checkZips
#' @name checkZips


checkZips <- function(x)
{
  cmdunzip <- Sys.which("unzip")

  out <- exists <- file.exists(x)

  # for all that exist do the test.
  for (j in seq_along(x[exists]))
  { # j=1
    res <- system(paste0(cmdunzip,' -t ', x[exists][j]), intern = TRUE)
    res <- res[length(res)]

    if (length(grep(res, pattern = 'No errors detected'))==0)
    {
      out[exists][j] <- FALSE
    }
  }
  return(out)
}

#' Function to convert several extent informations into API parameter 'geometry'
#' @description
#' This function will most probably become internal and is meant to convert several
#' R classes with a geographical extent information into the format as needed by the 
#' 'geometry' parameter (see value). 
#'
#' @param x one of the following classes: \code{Raster}, \code{Extent}, \code{sf},
#' \code{map} or \code{sp}
#'
#' @return
#' \code{character} string in the format: \code{'POINT(lon+lat)'} or 
#' \code{'POLYGON(lon+lat,lon+lat,lon+lat,....)'}
#'
#' @author
#' Robin Lovelace and Matteo Mattiuzzi
#'
#' @export geo2char
#' @name geo2char

# library(spData)
# library(sf)
# #> Linking to GEOS 3.8.0, GDAL 3.0.4, PROJ 7.0.0
# x_sf = rmapshaper::ms_simplify(lnd[1:3, ], 0.01)
# class(x_sf)
# x_sp = sf::as_Spatial(x_sf)
# class(x_sp)

geo2char = function(x) 
{
  # all rasters to a WGS84 extent then  to sp  
  if(inherits(x = x, what = "Raster"))
  {
    if(!raster::isLonLat(x))
    {
      x <- raster::projectExtent(x, crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
    }
    x <- raster::extent(x)
  }
  # Extent has no CRS infomration, we must trust that it is correct...(+add a note in the Rd file)
  if(inherits(x = x, what = "Extent")) 
  {
    # To avoid dependency to methods::as()
    x <- sp::SpatialPolygons(list(Polygons(list(Polygon(x)), ID = 1)))
    raster::crs(x) <- '+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
  }
  # ###################
  # # all terra::rast to a WGS84 extent the  to sp  
  # if(inherits(x = x, what =  "SpatRaster")|is(inherits(x = x, what = "SpatVector"))
  # {
  #   x <- rast()
  #   x <- vect()
  #     if(!isLonLat(x))
  #   {
  #   #  x <- 
  #       project(x,crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
  #   }
  #   x <- extent(x)
  # }
  # if(inherits(x = x, what = "Extent"))
  # {
  #   x <- sp::SpatialPoints(x)
  # }
  # ###################
  
  if(!inherits(x = x, what = "sf"))
  {
    x = sf::st_as_sf(x)
  }
  x <- sf::st_transform(x, crs = '+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
  
  # target string
  x <- sf::st_as_text(sf::st_geometry(x))
  
  # formatting
  x <- gsub(x, pattern = " \\(", replacement = "(")
  x <- gsub(x, pattern = ",", replacement = "%2C")
  x <- gsub(x, pattern = " ", replacement = "+")
  
return(x)
}


# extractDate <- function(x, unique = FALSE, as.POSIXlt=TRUE)
# {
#   x <- extractFilename(x)
#   for (i in 1:length(x))
#   { # i=1
#     x[i] <- strsplit(x[i],split = '_')[[1]][2]
#   }
#   if(unique)
#   {
#     x <- unique(x)
#   }
#   if(as.POSIXlt)
#   {
#     x <- as.POSIXlt(x, format =  "%Y%m%dT%H%M%S") # as.POSIXlt("2012-04-12T19:02:32Z", format="%Y-%m-%dT%H:%M:%SZ")
#   }
#   return(x)
# }
# isTif <- function(x)
# {
#   ext <- raster::extension(x)
#   return(ext == '.tif')
# }
#
# extractFilename <- function(x)
# {
#   if(!is.null(dim(x)))
#   {
#     x <- x[,1]
#   }
#
#   for (i in 1:length(x))
#   { # i=1
#     if(isTif(x[i]))
#     {
#       x[i] <- basename(x[i])
#     } else
#     {
#       x[i] <- strsplit(as.character(x[i]),';')[[1]][2]
#     }
#   }
#   return(x)
# }
#
# extractTiles <- function(x, unique = FALSE)
# {
#   x <- getFilename(x)
#   for (i in 1:length(x))
#   { # i=1
#     x[i] <- strsplit(x[i],split = '_')[[1]][4]
#   }
#
#   if(isTRUE(unique))
#   {
#     x <- unique(x)
#   }
#   return(x)
# }
#

