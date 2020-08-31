# clmsapi

R-Client for accessing the Copernicus Land Monitoring Service REST API on WEkEO. Currenty supported (on server side) are only Data from the High Resolution Snow and Ice Monitoring (https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-snow-and-ice-monitoring).
Before you download data you need to register here: https://cryo.land.copernicus.eu/finder. 

CLMS offers also a WMS frontend, see: https://cryo.land.copernicus.eu/browser.

The package is not at all mature yet, changes in methods and names are probably. 

currently working is: 

?composeUrl
x <- composeUrl(productType = 'FSC', productIdentifier = 'T29UNV', startDate='2020-07-01', completionDate=Sys.Date())

require(rjson)
x <- fromJSON(file = x)
x <- selector(x)
res <- downloader(x, user='yourUser', password='yourPassword')
res




