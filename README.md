# clmsapi

[![CRAN_version](http://www.r-pkg.org/badges/version/clmsapi)](https://cran.r-project.org/package=clmsapi)
[![CRAN_check](https://cranchecks.info/badges/worst/clmsapi)](https://cran.r-project.org/web/checks/check_results_clmsapi.html)
[![GitHub](https://img.shields.io/badge/license-CC--BY%204.0-green)](https://creativecommons.org/licenses/by/4.0/deed.en)

R-Client for accessing the Copernicus Land Monitoring Service HTTP API on WEkEO by means of REST calls. Currenty supported (on server side) are only Data from the High Resolution Snow and Ice Monitoring (https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-snow-and-ice-monitoring).
Before you download data you need to register here: https://cryo.land.copernicus.eu/finder. 

CLMS offers also a WMS frontend, see: https://cryo.land.copernicus.eu/browser.

## Maturity note 

**The package is not at all mature, changes in methods and names are to be expected!**   
**So far tested only on Linux and on Windows**

## Installation
To install from GitHub, first install **[devtools](https://cran.r-project.org/package=devtools)** and subsequently run

```S
devtools::install_github("MatMatt/clmsapi", ref = "master")

```

## Currently working is: 

?composeUrl  
x <- composeUrl(productType = 'FSC', productIdentifier = 'T29UNV', startDate='2020-07-01', completionDate=Sys.Date())

require(rjson)  
x <- fromJSON(file = x)  
x <- selector(x)  
res <- downloader(x, user='yourUser', password='yourPassword')  
res  

## Outlook
**clmsapi** will remmain as modular a possible and not go as far as covering any raster processing functionalities and it will alsways remain a utility package meant access CLSM data. 
Currently operative processed on WEKEO are only the Cryosphere products **HR-S&I part 1** (https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-snow-and-ice-monitoring), but soon also High Resolution Vegetation Phenology and Productivity **HR-VPP** (https://land.copernicus.eu/user-corner/technical-library/phenology) products will be hosted on WEkEO. Mid 2021 **HR-S&I part 2** is planned to commence operative production. These product will be gradually added to **clmsapi** as they become avialable on WEkEO. 

The main part covered by this package will remain the connection to the API, and the personal local data mirrow. You will be able to ask for the products you need, and **clmsapi** will give you back a ```character``` string with pathname and file name with the requested files. Thic covers (1) API call (works), (2) check the availability and integrity of local files (works), structured download of needed files (a bit hardcoded but works), unzip (todo). Further to be imporved are some comfort functionality, so to allow better translation from R spatial objects into ALI paramters. 


### Package downloads (CRAN)

This month      | In total
--------------- | -----------
![month](https://cranlogs.r-pkg.org/badges/clmsapi) | ![total](https://cranlogs.r-pkg.org/badges/clmsapi)

