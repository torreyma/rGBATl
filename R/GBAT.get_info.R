#' The \code{GBAT.get_info} provides a list of available return fields, version, and release information for a specific release or version of DCP's Geosupport geocoding software. These fields are described in \href{https://nycplanning.github.io/Geosupport-UPG/appendices/appendix13/}{Appendix 13 of the Geosupport System User Programming Guide}.
#' @details Geosupport can be downloaded from \href{https://www1.nyc.gov/site/planning/data-maps/open-data.page#geocoding_application}{DCP BYTES of the BIG APPLE}. Excellent documentation is provide in the \href{https://nycplanning.github.io/Geosupport-UPG/}{Geosupport System User Programming Guide}. 
#' @title Get a list containing return fields, version, and release information for a specific release or version of DCP's Geosupport geocoding software.
#' @name GBAT.get_info
#' @aliases GBAT.get_info
#' @export GBAT.get_info 
#' @param GBAT_name the release (e.g., "17B") or version (e.g.,"17.2") of DCP's Geosupport geocoding software as string.  Required.
#' @return A list of available return fields, version, and release information for a specific release or version of DCP's Geosupport geocoding software.
#' @examples 
#' #specify either Geosupport software version or data files release
#' my_GBAT_info <- GBAT.get_info("17.3")
#' 
#' #Geosupport software version
#' my_GBAT_info[["GBAT.version"]]
#' 
#' #Geosupport data files release
#' my_GBAT_info[["GBAT.release"]]
#' 
#' #return fields available
#' my.GBAT_flds <- my_GBAT_info[["GBAT.return_fields"]]
#' 
#' #preview return fields available for intersection addresses
#' head(my.GBAT_flds[my.GBAT_flds$GC_function %in% c("F2","all"),])
#'
#' #preview return fields available for standard addresses
#' head(my.GBAT_flds[my.GBAT_flds$GC_function %in% c("FAP","F1A","F1E","all"),])
#' 
#' #text string to search for return fields containing BBL (borough-block-lot)
#' my.GBAT_flds[grepl("BBL",my.GBAT_flds$GC_fldname,ignore.case=TRUE),]


GBAT.get_info <- function(GBAT_name) {

	if ((grepl("^[[:digit:]]{2}[[:alpha:]]{1}$",GBAT_name)) | (grepl("^[[:digit:]]{2}\\.[1-9]$",GBAT_name))){
		
		gc.pks <- GBAT.load_all()
		
		this.pks <- gc.pks[grepl(paste0("^",toupper(GBAT_name),"$"),gc.pks$Version) | grepl(paste0("^",toupper(GBAT_name),"$"),gc.pks$Release),]
		
		if(nrow(this.pks)>0){
		
			vGBAT <- as.character(this.pks[1,]$Version)
			rGBAT <- as.character(this.pks[1,]$Release)
		
		} else{
		
			e.m2 <- paste0('\nThe Geosupport version specified does not exist!\nPlease specify one of the following releases of Geosupport:\n', paste0(gc.pks$Release,collapse="\n"))
		
			stop(e.m2)
		
		}
	
	} else {
	
		stop('\nThe Geosupport version specified is in an incorrect format!  Appropriate formats include decimal (e.g., "17.1"; "17.2"; "17.3"; "17.4") or alphanumeric (e.g., "17A"; "17B"; "17C"; "17D").')
	}

	###load rda for requested GBAT version###
	my.GBAT_output <- getExportedValue(paste0("rGBAT",rGBAT),"GBAT_output")[,c("GC_function","GC_fldname","GC_comment","GC_length")]
	
	###############################################
	###deal with census fields and joined fields###
	###############################################
	
	tmp.jn <- joined_fields[(GC_join_fld1 %in% my.GBAT_output$GC_fldname) | (is.na(GC_join_fld1))]
	
	tmp.jn <- data.table::rbindlist(list(tmp.jn, joined_fields[GC_join_fld1 %in% gsub("^(FBN|FBL|F1E|F1A|FAP|F2)\\.","",tmp.jn$GC_fldname)]),use.names=TRUE,fill=TRUE)
	
	my.GBAT_output <- rbind(as.data.frame(my.GBAT_output), data.frame(tmp.jn[,c("GC_function","GC_fldname","GC_comment","GC_length")]))
	
	#############################
	#############################
	#############################
	
	return(list("GBAT.return_fields" = my.GBAT_output, "GBAT.release" = rGBAT, "GBAT.version" = vGBAT))
	
}
