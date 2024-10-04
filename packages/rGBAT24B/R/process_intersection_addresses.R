
###wrapper function for geocoding intersection with borough code
process_intersection_addresses <- function(in_df, street1_col_name, street2_col_name, boro_code1_col_name, source_cols, geocode_fields, boro_code2_col_name=NULL, com_dir_col_name=NULL, return_type="all") {
	
	grc_fld <- "F2.output.ret_code"

	ret_cols <- c(source_cols, geocode_fields)
	
	col_vec <- c(street1_col_name, street2_col_name, boro_code1_col_name)
	
	if(!(is.null(com_dir_col_name))) col_vec <- c(col_vec,com_dir_col_name)	
	if(!(is.null(boro_code2_col_name))) col_vec <- c(col_vec,boro_code2_col_name)
	
	in_df[,(col_vec):= lapply(.SD, as.character), .SDcols = col_vec]
	
	#aggregate duplicate addresses
	df_unq <- unique(in_df[,col_vec,with=FALSE])
	
	#add unique id
	df_unq[,u_id := .I]

	GC_df <- rGBAT24B:::GBAT_3_df(df_unq, "u_id", street1_col_name, street2_col_name, boro_code1_col_name, unique(c(geocode_fields,grc_fld)), boro_code2_col_name, com_dir_col_name)
	
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
