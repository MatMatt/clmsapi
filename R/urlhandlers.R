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


selector <- function(x, as.data.frame = FALSE)
{
  j <- 1
  g <- 0
  while(TRUE)
  {
    if(j==1)
    {
      xu           <- paste0(x,'&page=',j)
      q            <- rjson::fromJSON(file = xu)
      
      totalResults <- q$properties$totalResults
      maxPage      <- as.numeric(q$properties$query$appliedFilters$maxRecords)
      currentPage  <- q$properties$itemsPerPage

      fileSize <- localZip <- serverPath <- downloadUrl <- vector( length = totalResults)
    } else
    {
      xu          <- paste0(x,'&page=',j)
      q           <- rjson::fromJSON(file = xu)
      
      currentPage <- q$properties$itemsPerPage

    }
    if(currentPage==0)
    {
      break
    }    
    offset      <- q$properties$startIndex - 1

    for(i in 1:currentPage)
    {
      downloadUrl[i+offset] <- q$features[[i]]$properties$services$download$url
      serverPath[i+offset]  <- q$features[[i]]$properties$productIdentifier
      localZip[i+offset]    <- paste0(q$features[[i]]$properties$productIdentifier,'.zip')
      fileSize[i+offset]    <- q$features[[i]]$properties$services$download$size
      g <- g + 1
    }
    j <- j + 1
  }
  if(totalResults==0)
  {
    return(NULL)
  }  
  # temp solution
  downloadUrl <- downloadUrl[1:g]
  serverPath  <- serverPath[1:g]
  localZip    <- localZip[1:g]
  fileSize    <- fileSize[1:g]
  
  
  localZip <- gsub(localZip,pattern='/hrsi/CLMS/Pan-European/High_Resolution_Layers', replacement = 'CLMS/Pan-European/HRL')
  result   <- list(downloadUrl=downloadUrl, serverPath=serverPath, localZip=localZip, fileSize=fileSize)
  
  if(as.data.frame)
  {
    result <- as.data.frame(result)
  }

return(result)
}


