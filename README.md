# rGBATl
("arr-jee-battle" --- it's a lowercase L, not 1 or I.)

This package provides tools to interface with NYC's powerful [Geosupport](https://www.nyc.gov/site/planning/data-maps/open-data/dwn-gde-home.page) geocoding software from within the R programming language on Linux. It depends on the torreyma/rGBAT24B, which in turn requires you to download Geosupport from NYC DCP's website. See: https://github.com/torreyma/rGBAT24B for instructions.


## Installation
1. Manually download DCP's Geosupport (version 24B) from their website, and unzip it in your home directory before trying to install the rGBATl pacakge.
    * See instructions: https://github.com/torreyma/rGBAT24B
    * (rGBAT24B is the package that actually requires Geosupport, but rGBAT24B is a dependency of rGBATl)
2. In R, make sure you have the ```devtools``` package installed. Then run ```devtools::install_github("torreyma/rGBATl")```
3. If you got no errors, load and test the library, in R:
    * Load the library: ```library(rGBATl)```
    * Look at the help for the package: ```help(package=rGBATl)```
    * See the help for a specific function, something like ```?GBAT.process_freeform_addresses```
    * In the help for the function will be some example code you can run. Run that code in R and see if it works correctly. This is a good test to run before you try geocoding your own addresses.


## TODO
* I deleted the US_CB_PUMA_2000.rda file because it was too big for github. This will break the function(s) that use that rda. I should figure out the best way to fix this.
* Eventually: modify this package so you can use it with any version of Geosupport.
* Eventually: this package should run in R on Windows.


## License and credits
* The original package, rGBAT, was written by Gretchen Culp (https://github.com/gmculp), initially exclusively for use on DOHMH's RHEL R server. (rGBATl simply extends its use to generalized Linux for the public.)
* This package is released under an MIT license (see LICENSE file).
* Geosupport Desktop Edition™ copyrighted by the New York City Department of City Planning. This product is freely available to the public with no limitations. 


