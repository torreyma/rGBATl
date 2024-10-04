# rGBATl
("arr-jee-battle" --- it's a lowercase L, not 1 or I.)

This package provides tools to interface with NYC's powerful [Geosupport](https://www.nyc.gov/site/planning/data-maps/open-data/dwn-gde-home.page) geocoding software from within the R programming language on Linux. It requires you to download Geosupport from NYC DCP's website.

(This branch automatically installs the rGBAT24B package for you, so you don't need to do that separately.)


## Installation
1. First, you need to manually download NYC's geosupport version 24B from Bytes of the Big Apple:
    * Search for Linux version of Geosupport Desktop Edition, 24B on NYC DCP's BYTES of the BIG APPLE™ Archive page.
    * Or try this url for direct download: https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/linux_geo24b_24.2.zip
2. Unzip the downloaded file (linux_geo24b_24.2.zip) in your home directory so you get a version-24b_24.2/ directory with all the Geosupport libraries in it. 
    * Note: it's stupid, but it HAS to be in your home directory ($HOME/, ~/) and it has to have the name above or it won't work. (See hard installation section if you want to do it differently.)
    * Probably not a bad idea to run a ```chmod -r 755 version-24b_24.2``` to make all the files executable.
3. Clone this repo to your computer.
4. In R, open ```install_rGBAT24B.R```. 
    * Make sure your working directory is the top-level folder of the repo you cloned. 
    * Then run the code in install_rGBAT24B.R
    * This should compile and install the rGBATl package. (This is an R package.)
        * If you get an error about missing ```NYCgeo.h```, you haven't installed Geosupport correctly. Remember, you have to do that first.
5. Once the package successfully installs, you can load the package and check the help for how to use it, in R:
				```library(rGBATl)```
				```help(package = "rGBATl")```


## TODO
* I deleted the US_CB_PUMA_2000.rda file because it was too big for github. This will break the function(s) that use that rda. I should figure out the best way to fix this.

## License and credits
* The original package, rGBAT, was written by Gretchen Culp (https://github.com/gmculp), initially exclusively for use on DOHMH's RHEL R server. (rGBATl simply extends its use to generalized Linux for the public.)
* This package is released under an MIT license (see LICENSE file).
* Geosupport Desktop Edition™ copyrighted by the New York City Department of City Planning. This product is freely available to the public with no limitations. 


