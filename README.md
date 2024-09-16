# rGBAT-l
This package provides tools to interface with NYC's powerful [Geosupport](https://www.nyc.gov/site/planning/data-maps/open-data/dwn-gde-home.page) geocoding software from within the R programming language on Linux. It requires the torreyma/rGBAT24B, which in turn requires you to download Geosupport from NYC DCP's website. See: https://github.com/torreyma/rGBAT24B for instructions.


## Installation
1. Install the torreyma/rGBAT24B package from github which rGBAT-l needs:
    * rGBAT24B requires you to manually download DCP's Geosupport (version 24B) from their website, and unzip it in your home directory before installing the rGBAT24B pacakge.
    * See instructions: https://github.com/torreyma/rGBAT24B
2. In R, make sure you have the ```devtools``` package installed. Then run ```devtools::install_github("torreyma/rGBAT-l")```
3. If you got no errors, load and test the library, in R:
    * Load the library: ```library(rGBAT-l)```
        * Unfortunately there's no test for rGBAT24B to already have been installed. The only way to find out if everything is working is to run a test geocoding.
    * Look at the help for the package: ```help(package=rGBAT-l)
    * See the help for a specific function, something like ```?GBAT.process_freeform_addresses.R```
    * In the help for the function will be some example code you can run. Run that code in R and see if it works correctly. This is a good test to run before you try geocoding your own addresses.


## TODO
* I deleted the US_CB_PUMA_2000.rda file because it was too big for github. This will break the function(s) that use that rda. I should figure out the best way to fix this.
* I should make this package depend on rGBAT24B, so it can't be installed without it.
* Eventually: combine this package with 24B so it's just a single package to install.
* Eventually: modify this package so you can use it with any version of Geosupport.
* Eventually: this package should run in R on Windows.


## License and credits
* rGBAT was written by Gretchen Culp (https://github.com/gmculp), initially exclusively for use on DOHMH's RHEL R server. (rGBAT-l simply extends its use to generalized Linux for the public.)
* This package is released under an MIT license (see LICENSE file).
* Geosupport Desktop Edition™ copyrighted by the New York City Department of City Planning. This product is freely available to the public with no limitations. 


