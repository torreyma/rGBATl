#' The \code{GBAT.list_versions} provides a data frame containing available versions of DCP's Geosupport geocoding software which were downloaded from \href{https://www1.nyc.gov/site/planning/data-maps/open-data.page#geocoding_application}{DCP BYTES of the BIG APPLE}. 
#' @details Geosupport can be downloaded from \href{https://www1.nyc.gov/site/planning/data-maps/open-data.page#geocoding_application}{DCP BYTES of the BIG APPLE}. Excellent documentation is provide in the \href{https://nycplanning.github.io/Geosupport-UPG/}{Geosupport System User Programming Guide}. 
#' @title Available versions of DCP's Geosupport.
#' @name GBAT.list_versions
#' @aliases GBAT.list_versions
#' @export GBAT.list_versions 
#' @return A data frame containing available versions of DCP's Geosupport geocoding software.
#' @examples 
#' 
#' #available GBAT versions installed on R server
#' gc_versions <- GBAT.list_versions()

GBAT.list_versions <- function(){

	gc.pks <- GBAT.load_all()
	
	return(gc.pks[,c("Version","Release")])
}