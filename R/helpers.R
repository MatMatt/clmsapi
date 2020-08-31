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

