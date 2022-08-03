#' Downloads files from CLMS server
#'
#' @description
#' This function deals with the authenification and download the files.
#' (currently a bit hardcoded, will be improved soon)
#'
#' @param x \code{list}. The return of \code{\link{selector}} containint the
#' files to be donwloaded.
#' @param rootDir \code{character}. Default is current directory. Base location for the local archive. Inside
#' rootDir the function then creates a file structure similar to the one on the
#' server: e.g. (currently hard coded):
#' CLMS/Pan-European/HRL/Snow/FSC/2020/08/18/FSC_20200818T114635_S2B_T29UNV_V100_1.zip
#' @param user \code{character}. Your username on \url{https://cryo.land.copernicus.eu/finder/}
#' @param password \code{character}. Your password on \url{https://cryo.land.copernicus.eu/finder/}
#'
#' @return 
#' \code{vector} with path/filename to the locally stored zip archives.
#' 
#' @author
#' Matteo Mattiuzzi
#'
#' @examples
#' \dontrun{
#' x <- composeUrl(productType = 'FSC', productIdentifier = 'T29UNV',
#' startDate='2020-07-01', completionDate='2020-07-31')
#' x <- selector(x)
#' downloader(x, user='yourUser', password='yourPassword',rootDir=tempdir())
#' }
#'
#' @export downloader
#' @name downloader

downloader <- function(x , rootDir='./', user, password)
{
  if(is.null(x$localZip))
  {
    stop("x does not contain any files")
  }
  
  rootDir <- normalizePath(rootDir, winslash = '/')
  dir.create(rootDir,showWarnings = FALSE,recursive = TRUE)
  
  dest   <- paste0(rootDir, '/', x$localZip)
  exists <- checkZips(dest) 

  while(sum(exists)!=length(exists)) # do auth and get Token only if download is needed
  {
    token <- token(user = user, password = password)
    cmdcurl <- Sys.which('curl')[[1]]
    
    for(i in seq_along(dest[!exists]))
    { # i=1
      dir.create(dirname(dest[!exists][i]), showWarnings = FALSE, recursive = TRUE)
      url <- paste0(x$downloadUrl[!exists][i],'?token=', token)
      cat(dest[!exists][i],'\n')
      system(paste(cmdcurl, url, "-o", path.expand(dest[!exists][i])))
      if(file.size(path.expand(dest[!exists][i])) < 0.9*x$fileSize[!exists][i])# If downloaded file is smaller than 90% of the expected size restart download.
      {
        break # break for i loop and one level up into the while loop
      }
    }
    exists <- checkZips(dest) # check which files need to be downloaded
  }
return(dest)
}

token <- function(user, password)
{
  if(missing(user))
  {
    stop('"user" is missing! If not registered yet, you can do that here: https://cryo.land.copernicus.eu/finder/')
  }
  if(missing(password))
  {
    stop('"password" is missing! If not registered yet, you can do that here: https://cryo.land.copernicus.eu/finder/')
  }
  
  cmdcurl <- Sys.which('curl')[[1]]
  
  # I have my doubts that the handling of the token is properly done here.
  # But so far it seems to work...
  token <- system(paste0(cmdcurl,' -s -d client_id=PUBLIC -d username=',user,' -d password=',password,' -d grant_type=password https://cryo.land.copernicus.eu/auth/realms/cryo/protocol/openid-connect/token'),intern = TRUE)
  
  if(length(grep(token, pattern = 'error'))!=0)
  {
    stop('Authentification error, please check your credentials for https://cryo.land.copernicus.eu/finder/.')
  }
  
  token <- strsplit(token,split = '\"')[[1]][4]
  return(token)
}
