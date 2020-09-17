#' Extract information from API reply.
#'
#' @description
#' Extract file location information (sources and dests) from the API reply
#'
#' @param x \code{character}. The return of \code{\link{composeUrl}} or the REST
#' query generated from the portal \url{https://cryo.land.copernicus.eu/finder/}.
#' @param as.data.frame \code{logical}. FALSE. If true the return is converted to
#' a data.frame
#'
#' @return
#' \code{list} or data.frame if \code{as.data.frame==TURE}
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @examples
#' \dontrun{
#' x <- composeUrl(productType = 'FSC', productIdentifier = 'T29UNV')
#' stopifnot(require(rjson))
#' x <- fromJSON(file = x)
#' selector(x)
#'}
#'
#' @export selector
#' @name selector


selector <- function(x, as.data.frame=FALSE)
{
  totalResults <- x$properties$totalResults

  fileSize <- localZip <- serverPath <- downloadUrl <- vector(length = totalResults)
  for(i in 1:totalResults)
  {
    downloadUrl[i] <- x$features[[i]]$properties$services$download$url
    serverPath[i]  <- x$features[[i]]$properties$productIdentifier
    localZip[i]    <- paste0(x$features[[i]]$properties$productIdentifier,'.zip')
    fileSize[i]    <- x$features[[i]]$properties$services$download$size
  }
  localZip <- gsub(localZip,pattern='/hrsi/CLMS/Pan-European/High_Resolution_Layers', replacement = 'CLMS/Pan-European/HRL')
  result <- list(downloadUrl=downloadUrl,serverPath=serverPath,localZip=localZip, fileSize=fileSize)
  
  if(as.data.frame)
  {
    result <- as.data.frame(result)
  }

return(result)
}


