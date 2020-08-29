#' Extract information from API reply
#'
#' @description
#' Extract file location information (sources and dests) from the API reply
#'
#' @param x \code{character}. Either the \code{queryURL} from the REST query in the portal
#' or the result of the \code{\link{composeQuery}}
#' @param as.data.frame \code{logical}. FALSE. If true the return is converted to
#'  a data.frame
#'
#' @return
#' \code{list} or data.frame if \code{as.data.frame==TURE}
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @examples
#'
#' @export selector
#' @name selector


selector <- function(x, as.data.frame=FALSE)
{
  totalResults <- x$properties$totalResults

  fileSize <- localPath <- serverPath <- downloadUrl <- vector(length = totalResults)
  for(i in 1:totalResults)
  {
    downloadUrl[i] <- x$features[[i]]$properties$services$download$url
    serverPath[i]  <- x$features[[i]]$properties$productIdentifier
    localPath[i]   <- x$features[[i]]$properties$productIdentifier
    fileSize[i]    <- x$features[[i]]$properties$services$download$size
  }
  localPath <- gsub(localPath,pattern='/hrsi/CLMS/Pan-European/High_Resolution_Layers', replacement = 'CLMS/Pan-European/HRL')
  result <- list(downloadUrl=downloadUrl,serverPath=serverPath,localPath=localPath, fileSize=fileSize)
  if(as.data.frame)
  {
    result <- as.data.frame(result)
  }

return(result)
}


