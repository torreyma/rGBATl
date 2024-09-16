#' The \code{GBAT.fields_by_version} function provides a crosstab data table containing return fields available for each version of DCP's Geosupport geocoding software. These fields are described in \href{https://nycplanning.github.io/Geosupport-UPG/appendices/appendix13/}{Appendix 13 of the Geosupport System User Programming Guide}.
#' @details Geosupport can be downloaded from \href{https://www1.nyc.gov/site/planning/data-maps/open-data.page#geocoding_application}{DCP BYTES of the BIG APPLE}. Excellent documentation is provide in the \href{https://nycplanning.github.io/Geosupport-UPG/}{Geosupport System User Programming Guide}. The geocoder return fields are described in \href{https://nycplanning.github.io/Geosupport-UPG/appendices/appendix13/}{Appendix 13 of the Geosupport System User Programming Guide}.
#' @title Crosstab of return fields available for each version of Geosupport.
#' @name GBAT.fields_by_version
#' @aliases GBAT.fields_by_version
#' @import data.table
#' @export GBAT.fields_by_version 
#' @return A crosstab data frame containing return fields available for each version of DCP's Geosupport geocoding software.
#' @examples 
#' 
#' #generate crosstab
#' gc_fld_by_ver <- GBAT.fields_by_version()
#' 
#' #check which versions output address point id and USPS city name
#' gc_fld_by_ver[gc_fld_by_ver$GC_fldname %in% 
#'     c("FAP.ap_id","F1E.USPS_city_name"),]
#' 
#' #check which versions output joined fields
#' gc_fld_by_ver[grepl("^JN",gc_fld_by_ver$GC_fldname),]

GBAT.fields_by_version <- function(){

	gc.pks <- GBAT.load_all()
	DT.c2 <- rbindlist(lapply(gc.pks$Version,function(j){
		temp.dt <- as.data.table(GBAT.get_info(j)$GBAT.return_fields)
		temp.dt[,variable := paste0("v",j)]
		temp.dt[,value := 1]
		return(unique(temp.dt[,c("GC_fldname","variable","value"),with=FALSE]))
	}),use.names=TRUE,fill=TRUE)		

	DT.c2 <- dcast(DT.c2, GC_fldname ~ variable, value.var = "value")
	DT.c2 <- melt(DT.c2, id.vars = c("GC_fldname"))
	DT.c2[,value := ifelse(is.na(value),0,value)]
	DT.c2 <- dcast(DT.c2, GC_fldname ~ variable, value.var = "value")
	
	return(as.data.frame(DT.c2))
}