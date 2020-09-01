#' Compile the URL to query the CLMS API
#'
#' @description
#' This function compiles REST query (URL) that can be submitted to the server.
#'
#' @param productType \code{character}. One of: FSC, RLIE, PSA, PSA-LAEA, ARLIE
#' @param productIdentifier \code{character}. Find products using elements of the
#' filename: FSC_20170913T114531_S2B_T29UNV_V001_0: e.g. FSC_2020, TileID, etc.
#' (its not regex though)
#' @param geometry \code{character}, NOT IMPLEMENTED YET. WKT string derining 
#' the area of interest. (POINT, POLYGON, etc.) in WGS84 projection.
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


composeUrl <- function(productType=c('FSC','RLIE','PSA','PSA-LAEA','ARLIE'), geometry, publishedAfter, publishedBefore, startDate, completionDate, productIdentifier, cloudCover=100, textualSearch, maxRecords = 1000)
{

  # Request URL root
  HRSIroot = 'https://cryo.land.copernicus.eu/resto/api/collections/HRSI/search.json'

  # Static URL parameters.
  # status all: request all processed products
  # maxRecords: request n products per page.
  # dataset: request within ESA-DATASET.
  # sortParam: results are sorted according start date.
  # sortOrder: results are sorted in descending order (most recent first).
  staticP <- paste('sortParam=startDate','sortOrder=descending','status=all','dataset=ESA-DATASET', sep='&')

  # if(!missing(queryURL))
  # {
  #   return(queryURL)
  # }

  productType <- toupper(productType)
  if(sum(productType == c('FSC','RLIE','PSA','PSA-LAEA','ARLIE'))!=1)
  {
    stop('"productType" must be one of: FSC, RLIE, PSA, PSA-LAEA, ARLIE')
  } else
  {
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

  # if(!missing(geometry))
  # {
  #   
  #   geometry <- paste0("geometry=",gsub(geometry, pattern = ' ', replacement = '+'), "&")
  # } else
  # {
  #   geometry <- NULL
  # }
  
  
  #geometry=POLYGON((13.990623171919392+48.33851249150035%2C14.65623466020064+48.33851249150035%2C14.73610803879439+48.03230693902546%2C13.990623171919392+48.054557235193585%2C13.990623171919392+48.33851249150035))
  #geometry=POINT(14.360037547915486+48.30531787964546)
  # geometry=POINT(lon+lat)
  
  stat <- paste0(HRSIroot,'?',maxRecords)
  url  <- paste0(stat,productIdentifier,startDate,completionDate, publishedAfter,publishedBefore,productType,q,staticP)

  return(url)
}
