# rGBATl
("arr-jee-battle" --- it's a lowercase L, not 1 or I.)

This package provides tools to interface with NYC's powerful [Geosupport](https://www.nyc.gov/site/planning/data-maps/open-data/dwn-gde-home.page) geocoding software from within the R programming language on Linux. It depends on the torreyma/rGBAT24B package, which in turn requires you to manually and unzip download Geosupport from NYC DCP's website outside of R. 


## Installation
1. Manually download NYC's Geosupport version 24B from Bytes of the Big Apple:
    * Search for Linux version of Geosupport Desktop Edition, 24B on NYC DCP's BYTES of the BIG APPLE™ Archive page.
    * Or try this url for direct download: https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/linux_geo24b_24.2.zip
2. Unzip the downloaded file (linux_geo24b_24.2.zip) in your home directory so you get a `version-24b_24.2/` directory with all the Geosupport libraries in it. 
    * Note: this is stupid, but it HAS to be in your home directory ($HOME/, ~/) and it has to have the name above or it won't work. (See torreyma/rGBAT24B github repo if you want to do it differently.)
    * Probably not a bad idea to run a `chmod -r 755 version-24b_24.2` to make all the files executable.
2. In R, make sure you have the `devtools` package installed. Then run `devtools::install_github("torreyma/rGBATl")`
    * rGBATl depends on and will try to compile and install torreyma/rGBAT24B. If something goes wrong, your first troubleshooting step should be to try to install rGBAT24B separately from rGBATl. See: https://github.com/torreyma/rGBAT24B. 
3. If you got no errors, load and test the library, in R:
    * Load the library: `library(rGBATl)`
    * Look at the help for the package: `help(package=rGBATl)`
    * See the help for a specific function, something like `?GBAT.process_freeform_addresses`
    * In the help for the function will be some example code you can run. Run that code in R and see if it works correctly. This is a good test to run before you try geocoding your own addresses.


## TODO
* I deleted the US_CB_PUMA_2000.rda file because it was too big for github. This will break the function(s) that use that rda. I should figure out the best way to fix this.
* Eventually: modify this package so you can use it with any version of Geosupport.
* Eventually: this package should run in R on Windows. For a temporary workaround Windows installation option that may or may not work, see: https://github.com/torreyma/rGBAT-win


## License and credits
* The original package, rGBAT, was written by Gretchen Culp (https://github.com/gmculp), initially exclusively for use on DOHMH's RHEL R server. (rGBATl simply extends its use to generalized Linux for the public.)
* This package is released under an MIT license (see LICENSE file).
* Geosupport Desktop Edition™ copyrighted by the New York City Department of City Planning. This product is freely available to the public with no limitations. 




