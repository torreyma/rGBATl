
###wrapper function for geocoding with boro or zip code
process_freeform_addresses <- function(in_df, addr_col_name, unit_col_name=NULL, third_col_name, source_cols, geocode_fields, third_col_type="boro_code", return_type="all") {
	
	grc_fld <- "F1E.output.ret_code"

	ret_cols <- c(source_cols, geocode_fields)
	
	col_vec <- c(addr_col_name,third_col_name)
	
	if(!(is.null(unit_col_name))) col_vec <- c(col_vec,unit_col_name)
	
	in_df[,(col_vec):= lapply(.SD, as.character), .SDcols = col_vec]
	
	#aggregate duplicate addresses
	df_unq <- unique(in_df[,col_vec,with=FALSE])
	
	#add unique id
	df_unq[,u_id := .I]

	third_col_type <- ifelse(grepl("^Z.*$", third_col_type, ignore.case = TRUE), "zip_code","boro_code")
	
	GC_df <- rGBAT24B:::GBAT_1_df(df_unq, "u_id", addr_col_name, third_col_name, third_col_type, unique(c(geocode_fields,grc_fld)), unit_col_name)
	
	#discard extraneous columns
	GC_df <- GC_df[,unique(c(col_vec,geocode_fields,grc_fld)),with=FALSE]

	#join back to original
	output_df <- merge(in_df, GC_df, by=col_vec)

	invisible(gc())
	
	#option to return only successfully geocoded records
	if (return_type != "all") {
		return(unique(output_df[get(grc_fld) == "00" | get(grc_fld) == "01", ret_cols, with=FALSE]))
	} else {
		return(output_df[,ret_cols,with=FALSE])
	}
	
}
