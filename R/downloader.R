downloader <- function(x , rootDir='./', username, password)
{

  for(i in seq_along(x$downloadUrl))
  {
    dest <- dirname(paste0(rootDir, x$localPath[i]))
    dir.create(dest, showWarnings = FALSE, recursive = TRUE)
    download.file(url = x$downloadUrl[i], destfile = paste0(rootDir, x$localPath[i],'.zip'), CURLOPT_USERPWD = credentials)
  }
}
