#' Compile the URL to query the CLMS API
#'
#' @description
#' This function compiles REST query (URL) that can be submitted to the server.
#'
#' @param productType \code{character}. One of: FSC, GFSC, SWS, WDS, RLIE, PSA, PSA_LAEA, ARLIE
#' @param productIdentifier \code{character}. Find products using elements of the
#' filename: FSC_20170913T114531_S2B_T29UNV_V001_0: e.g. FSC_2020, TileID, etc.
#' (its not regex thought)
#' @param geometry The area of interest. See \code{geo2char} for inputs.
#' @param publishedAfter \code{character}. Data published after: YYYY-MM-DD
#' @param publishedBefore \code{character}. Data published before: YYYY-MM-DD
#' @param startDate \code{character}. Sensing Date after: YYYY-MM-DD
#' @param completionDate \code{character}. Sensing Date before: YYYY-MM-DD
#' @param cloudCover \code{integer}. \code{0-100\%}. Maximum allowed Cloud cover
#' @param textualSearch \code{character} e.g. \code{Winter in Finland}
#' @param maxRecords \code{numeric or character} maximum returns per page.
#'
#' @return
#' Returns an URL \code{character} that can be submitted to the Server API.
#'
#' @author
#' Matteo Mattiuzzi
#'
#' @examples
#' composeUrl(productType = 'FSC', productIdentifier = 'T29UNV')
#'
#' @export composeUrl
#' @name composeUrl


composeUrl <- function(productType=c('FSC','GFSC', 'RLIE','SWS', 'WDS', 'PSA','PSA_LAEA','ARLIE'), geometry, publishedAfter, publishedBefore, startDate, completionDate, productIdentifier, cloudCover=100, textualSearch, maxRecords = 1000)
{

  # Request URL root
  HRSIroot = 'https://cryo.land.copernicus.eu/resto/api/collections/HRSI/search.json'
  
  # Static URL parameters.
  # status all: request all processed products
  # maxRecords: request n products per page.
  # dataset: request within ESA-DATASET.
  # sortParam: results are sorted according start date.
  # sortOrder: results are sorted in descending order (most recent first).
  
  
  staticP <- paste('sortParam=startDate','sortOrder=descending','status=all',
                   'dataset=ESA-DATASET', sep='&')

  productType <- toupper(productType)
  if(sum(productType == c('FSC','GFSC', 'RLIE','SWS', 'WDS', 'PSA','PSA_LAEA','ARLIE'))!=1)
  {
    stop('"productType" must be one of: FSC, GFSC, SWS, WDS, RLIE, PSA, PSA_LAEA, ARLIE')
  } else
  {
    # this is a error on server side... will be removed here once its solved on 
    # server side.
    productType <- gsub(productType,pattern = 'PSA$', replacement = 'PSA_WGS84')
    productType <- paste0('productType=', productType,'&')
  }
  if(!missing(publishedAfter))
  {
    publishedAfter <- paste0('publishedAfter=',publishedAfter,'T3A00%3A00%3A00Z&')
  } else
  {
    publishedAfter <- NULL
  }

  if(!missing(publishedBefore))
  {
    publishedBefore <- paste0('publishedBefore=',publishedBefore,'T23%3A59%3A59Z&')
  } else
  {
    publishedBefore <- NULL
  }

  if(!missing(startDate))
  {
    startDate <- paste0('startDate=',startDate,'T00%3A00%3A00Z&')
  } else
  {
    startDate <- NULL
  }

  if(!missing(completionDate))
  {
    completionDate <- paste0('completionDate=', completionDate,'T23%3A59%3A59Z&')
  } else
  {
    completionDate <- NULL
  }

  cloudCover <- paste0('%5B0%2C',cloudCover,'%5D&')

  if(!missing(productIdentifier))
  {
    productIdentifier <- paste0("productIdentifier=%25",productIdentifier, "%25&")
  } else
  {
    productIdentifier <- NULL
  }

  if(!missing(textualSearch))
  {
    q <- paste0("q=",gsub(textualSearch, pattern = ' ', replacement = '+'), "&")
  } else
  {
    q <- NULL
  }

  maxRecords <- paste0('maxRecords=', maxRecords,'&')

  if(!missing(geometry))
  {
    geometry <- geo2char(geometry)
    geometry <- paste0("geometry=",geometry, "&")
  } else
  {
    geometry <- NULL
  }
  
  stat <- paste0(HRSIroot,'?',maxRecords)
  url  <- paste0(stat,productIdentifier,startDate,completionDate, publishedAfter,publishedBefore,productType,geometry,q,staticP)

return(url)
}
