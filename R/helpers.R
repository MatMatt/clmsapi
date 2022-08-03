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
  out <- exists <- file.exists(x)

  if(.Platform$OS.typ== "unix")
  {
    cmdunzip <- Sys.which("unzip")
  
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
    x <- sp::SpatialPolygons(list(sp::Polygons(list(sp::Polygon(x)), ID = 1)))
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

getExtension <- function(x)
{
  x <- basename(x)  
  
  for(i in seq_along(x))
  {
    xx <- strsplit(x[i],split = '\\.')[[1]]
    x[i] <- xx[length(xx)]
  }
  return(x)
}

#' Isolate an element from a filename
#' @description
#' Isolate an element from a vector of filenames (mostly an internal function).   
#'
#' @param x filename(s)
#' @param split set name splitting character \code{'_'} 
#' @param position \code{numeric} default 2. Set the position of the element to be extreacted 
#'
#' @return
#' \code{character} string with the extracted name element
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @export extractFromName
#' @name extractFromName

extractFromName <- function(x, split = '_', position=2)
{
  x <- basename(x)
  for (i in seq_along(x))
  { # i=1
    x[i] <- strsplit(x[i], split = split)[[1]][position]
  }
  return(x)
}

#' Extracts the date from the filename
#' @description
#' Extract the date in the filename and converts it into a POSIX object.  
#'
#' @param x filename
#' @param split argument to isolate the date information. default \code{'_'} 
#' @param position \code{numeric} default 2. Set the position of the date after 
#' the \code{split} was applied 
#' @param format argument passed to \code{as.POSIXlt}. default \code{"%Y%m%dT%H%M%S"}
#'
#' @return
#' POSIXlt objects string.
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @export extractDate
#' @name extractDate

extractDate <- function(x, split = '_', position=2, format= "%Y%m%dT%H%M%S")
{
  x <- extractFromName(x,split = split, position = position)
  x <- as.POSIXlt(x, format =  format) # as.POSIXlt("2012-04-12T19:02:32Z", format="%Y-%m-%dT%H:%M:%SZ")
  
  return(x)
}

tileName <- function(x, split = '_', position=4)
{
  x <- basename(x)
  for (i in seq_along(x))
  { # i=1
    x[i] <- strsplit(x[i],split = split)[[1]][position]
  }

  return(x)
}

#' Basic wrapper around utils::unzip to allow unzippping of mutiple files.
#' @description
#' This function allows to unzip a verctor of zip files at once. 
#'
#' @param zipfile vector containing path to zipfiles 
#' @param exdir default \code{dirname(zipdir)}
#'
#' @return
#' \code{character} string with \code{exdir} pathnames.
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @export listUnzip
#' @name listUnzip

listUnzip <- function(zipfile, exdir)
{
  
  if(missing(exdir))
  {
    exdir <- dirname(zipfile)
  }
  
  for(i in seq_along(zipfile))
  { 
    exdir[i] <- unique(dirname(utils::unzip(zipfile = zipfile[i], exdir = exdir[i])))
  }
return(exdir)
}

