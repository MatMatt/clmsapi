# clmsapi

R-Client for accessing the Copernicus Land Monitoring Service HTTP API on WEkEO by means of REST calls. Currently supported are only data from the [High Resolution Snow and Ice Monitoring](https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-snow-and-ice-monitoring).

## Registration:
Before downloading any data using the clmsapi, you need to register [here](https://cryo.land.copernicus.eu/finder/).

## Other Data access possibilities:
Web frontend for seach and download: https://cryo.land.copernicus.eu/finder/  
WEkEO catalogue (will gradually become the standard) https://www.wekeo.eu/data?view=catalogue  
WMS services:  
•	https://cryo.land.copernicus.eu/wms/FSC/  
•	https://cryo.land.copernicus.eu/wms/RLIE/  
•	https://cryo.land.copernicus.eu/wms/PSA/  
•	https://cryo.land.copernicus.eu/wms/GFSC/  
•	https://cryo.land.copernicus.eu/wms/WDS/  
•	https://cryo.land.copernicus.eu/wms/SWS/  

## API Url: 
https://cryo.land.copernicus.eu/resto/api/collections/HRSI/search.json  

## API reference: 
https://cryo.land.copernicus.eu/resto/api/collections/HRSI/describe.xml

## Package maturity note 
**The package is not at all mature, changes in methods and names are to be expected!**   
**So far tested only on Linux and on Windows.**

## Installation
To install from GitHub, first install **[devtools](https://cran.r-project.org/package=devtools)** and subsequently run

```S
devtools::install_github("MatMatt/clmsapi", ref = "master")

```

## Currently working is: 
```S
x <- composeUrl(productType = 'FSC', productIdentifier = 'T29UNV', startDate='2020-07-01', completionDate=Sys.Date())
x <- selector(x)  
res <- downloader(x, user='yourUser', password='yourPassword')  
res  
```

## Outlook
**clmsapi** will remain a modular utility package and most probably not go as far as covering any raster processing functionalities.
Currently operativ on WEkEO is only the **High Resolution Snow and Ice** ([HR-S&I](https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-snow-and-ice-monitoring)). In 2021 two more product will commence on WEkEO, (1) the **High Resolution Vegetation Phenology and Productivity** ([HR-VPP](https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-vegetation-phenology-and-productivity)). Products might be gradually added to **clmsapi** as they become avialable on WEkEO (and my time permitting!). 

The main part covered by this package will remain the connection to the API, and the personal local data mirrow. You will be able to ask for the products you need, and **clmsapi** will give you back a ```character``` string with path- and filename of the requested files. This covers (1) API call (works), (2) check the availability and integrity of local files (works), (3) structured download of needed files (a bit hardcoded but works), (4) unzip (todo). Further to be imporved are some comfort functionality, so to allow better translation from R spatial objects (extent information) into API paramter 'geometry'. 

## Legal notice about Copernicus Data:
Access to data is based on a principle of full, open and free access as established by the Copernicus data and information policy Regulation (EU) No 1159/2013 of 12 July 2013. This regulation establishes registration and licensing conditions for GMES/Copernicus users and can be found here: https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32013R1159.  

Free, full and open access to this data set is made on the conditions that:  
1. When distributing or communicating Copernicus dedicated data and Copernicus service information to the public, users shall inform the public of the source of that data and information.  
2. Users shall make sure not to convey the impression to the public that the user's activities are officially endorsed by the Union.  
3. Where that data or information has been adapted or modified, the user shall clearly state this.  
4. The data remain the sole property of the European Union. Any information and data produced in the framework of the action shall be the sole property of the European Union. Any communication and publication by the beneficiary shall acknowledge that the data were produced “with funding by the European Union”.  

