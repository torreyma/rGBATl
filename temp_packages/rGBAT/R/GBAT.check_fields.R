#helper function to check if user requested Geosupport return fields exist.

GBAT.check_fields <- function(GBAT_name,geocode_functions,geocode_fields){

	iGBAT <- GBAT.get_info(GBAT_name)

	my.GBAT_output <- iGBAT[["GBAT.return_fields"]]
	my.GBAT_output <- my.GBAT_output[my.GBAT_output$GC_function %in% unique(geocode_functions),]
	
	my.g_cols <- unique(geocode_fields)	
	my.g_cols.ok <- my.g_cols[my.g_cols %in% as.character(my.GBAT_output$GC_fldname)]
	my.g_cols.fail <- my.g_cols[!(my.g_cols %in% as.character(my.GBAT_output$GC_fldname))]

	if (length(my.g_cols.ok)>0){
		if(length(my.g_cols.fail)>0){
			
			my.message <- paste0("The following Geosupport return columns do not exist for this function:\n",paste0(my.g_cols.fail,collapse="\n"),"\nThese columns have been omitted from the output.")
			
			my.status <- 2
			
		} else {
			
			my.message <- ""
			
			my.status <- 1
			
		}
	
	} else {
		
		my.message <- paste0('\nThe following Geosupport return columns do not exist:\n',paste0(my.g_cols.fail,collapse='\n'),'\nPlease enter the following line of code to see a available return columns:\n', paste0('GBAT.get_info(',GBAT_name,')[["my.GBAT_output"]]'),'[,c("GC_fldname","GC_comment")]')
		
		my.status <- 3
		
	}
	
	#return list of status, function and messages
	return(list("GBAT.status" = my.status, "GBAT.message" = my.message, "GBAT.release" = iGBAT[["GBAT.release"]], "GBAT.fields" = my.g_cols.ok))
	
}