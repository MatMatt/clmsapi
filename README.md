# clmsapi

[![CRAN_version](http://www.r-pkg.org/badges/version/clmsapi)](https://cran.r-project.org/package=clmsapi)
[![CRAN_check](https://cranchecks.info/badges/worst/clmsapi)](https://cran.r-project.org/web/checks/check_results_clmsapi.html)

R-Client for accessing the Copernicus Land Monitoring Service HTTP API on WEkEO by means of REST calls. Currenty supported (on server side) are only Data from the High Resolution Snow and Ice Monitoring (https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-snow-and-ice-monitoring).
Before you download data you need to register here: https://cryo.land.copernicus.eu/finder. 

CLMS offers also a WMS frontend, see: https://cryo.land.copernicus.eu/browser.

**The package is not at all mature yet, changes in methods and names are to be expected!**   
**So far tested only on Linux**

Currently working is: 

?composeUrl  
x <- composeUrl(productType = 'FSC', productIdentifier = 'T29UNV', startDate='2020-07-01', completionDate=Sys.Date())

require(rjson)  
x <- fromJSON(file = x)  
x <- selector(x)  
res <- downloader(x, user='yourUser', password='yourPassword')  
res  


### Package downloads

This month      | In total
--------------- | -----------
![month](https://cranlogs.r-pkg.org/badges/clmsapi) | ![total](https://cranlogs.r-pkg.org/badges/clmsapi)

