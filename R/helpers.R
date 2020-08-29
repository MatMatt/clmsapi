isTif <- function(x)
{
  ext <- raster:::extension(x)
  return(ext == '.tif')
}

extractFilename <- function(x)
{
  if(!is.null(dim(x)))
  {
    x <- x[,1]
  }

  for (i in 1:length(x))
  { # i=1
    if(isTif(x[i]))
    {
      x[i] <- basename(x[i])
    } else
    {
      x[i] <- strsplit(as.character(x[i]),';')[[1]][2]
    }
  }
  return(x)
}

extractTiles <- function(x, unique = FALSE)
{
  x <- getFilename(x)
  for (i in 1:length(x))
  { # i=1
    x[i] <- strsplit(x[i],split = '_')[[1]][4]
  }

  if(isTRUE(unique))
  {
    x <- unique(x)
  }
  return(x)
}

#' Helper Functions
#' @description
#' This function extracts the Date from CLMS filenames and from paths returned by the API.
#'
#' @param x \code{character}, vector with filenames and paths returned by the server.
#' @param unique \code{logical}. \code{FALSE}. Should the result be collapsed using \code{\link{unique()}}
#' @param as.POSIXlt \code{logical}. \code{TRUE}. Convert character string be converted to \code{POSIXlt}?
#'
#' @return
#' If \code{as.POSIXlt=TRUE} the function returns class \code{POSIXlt}, else a \code{character}.
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @seealso
#' \code{\link{as.POSIXlt}}
#'
#' @examples
#'
#' @export extractDate
#' @name extractDate

extractDate <- function(x, unique = FALSE, as.POSIXlt=TRUE)
{
  x <- extractFilename(x)
  for (i in 1:length(x))
  { # i=1
    x[i] <- strsplit(x[i],split = '_')[[1]][2]
  }
  if(unique)
  {
    x <- unique(x)
  }
  if(as.POSIXlt)
  {
    x <- as.POSIXlt(x, format =  "%Y%m%dT%H%M%S") # as.POSIXlt("2012-04-12T19:02:32Z", format="%Y-%m-%dT%H:%M:%SZ")
  }
  return(x)
}
