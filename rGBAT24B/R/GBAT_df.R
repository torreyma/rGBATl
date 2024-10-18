
###wrapper function for parsing output
GBAT_1_df <- function(x, id_col, addr_col_name, third_col_name, third_col_type, geocode_fields, unit_col_name=NULL) {

  if(is.null(unit_col_name)) unit_col_name=""

  ###convert to data.table###
  out_df <- as.data.table(rGBAT24B:::GBAT_1(x, id_col, addr_col_name, third_col_name, third_col_type, unit_col_name))
  
  ###load meta data table for specific GBAT version###
  GBAT_o <- rGBAT24B::GBAT_output
  
  ###extract all output fields related to census geographies###
  cen_vec <- GBAT_o[grepl("\\.cen_blk|(\\.|_)cen_tract",GC_fldname) & GC_function %in% c("F1E","F1A","FAP")]$GC_fldname
  
  ###added to deal with fields missing in earlier versions###
  cen_vec <- c(cen_vec,"F1A.San.sanborn_boro","F1E.key.lion_boro")
  
  GBAT_output_sub <- GBAT_o[GC_fldname %in% c(geocode_fields,cen_vec,"F1E.mh_ri_flag")]
  
  #break output into fixed width columns
  for(i in 1:nrow(GBAT_output_sub)){
	this_pat <- ifelse(as.character(GBAT_output_sub$GC_fldname[i]) %in% cen_vec,"\\s","(?<=[\\s])\\s*|^\\s+|\\s+$")
	this_rep <- ifelse(as.character(GBAT_output_sub$GC_fldname[i]) %in% cen_vec,"0","")
	this_fld <- paste0(as.character(GBAT_output_sub$GC_function[i]),".output")
	this_start <- GBAT_output_sub$GC_start[i]
	this_stop <- GBAT_output_sub$GC_end[i]
	this_name <- as.character(GBAT_output_sub$GC_fldname[i])
	out_df[,(this_name) := gsub(this_pat, this_rep, substr(get(this_fld), this_start, this_stop), perl=TRUE)]
  }	
  
  #remove space delimited output
  out_df[,c("F1A.output","F1E.output","FAP.output") := NULL]
  
  
  ###edit 03/22/2021: deal with misassignment of Marble Hill and Rikers Island borough codes###
  out_df[,F1E.key.lion_boro := ifelse(toupper(F1E.mh_ri_flag)=="M",'1',ifelse(toupper(F1E.mh_ri_flag)=="R",'2',F1E.key.lion_boro))]
  
  #get version
  out_df$GC.version <- "24b_24.2"

  return(rGBAT24B:::GBAT_census_format(out_df))
  
}

GBAT_2_df <- function(x, id_col, hse_num_col, addr_col_name, third_col_name, third_col_type, geocode_fields, unit_col_name=NULL) {

  if(is.null(unit_col_name)) unit_col_name=""

  ###convert to data.table###
  out_df <- as.data.table(rGBAT24B:::GBAT_2(x, id_col, hse_num_col, addr_col_name, third_col_name, third_col_type, unit_col_name))
  
  ###load meta data table for specific GBAT version###
  GBAT_o <- rGBAT24B::GBAT_output
  
  ###extract all output fields related to census geographies###
  cen_vec <- GBAT_o[grepl("\\.cen_blk|(\\.|_)cen_tract",GC_fldname) & GC_function %in% c("F1E","F1A","FAP")]$GC_fldname
  
  ###added to deal with fields missing in earlier versions###
  cen_vec <- c(cen_vec,"F1A.San.sanborn_boro","F1E.key.lion_boro")
  
  GBAT_output_sub <- GBAT_o[GC_fldname %in% c(geocode_fields,cen_vec,"F1E.mh_ri_flag")]
  
  #break output into fixed width columns
  for(i in 1:nrow(GBAT_output_sub)){
	this_pat <- ifelse(as.character(GBAT_output_sub$GC_fldname[i]) %in% cen_vec,"\\s","(?<=[\\s])\\s*|^\\s+|\\s+$")
	this_rep <- ifelse(as.character(GBAT_output_sub$GC_fldname[i]) %in% cen_vec,"0","")
	this_fld <- paste0(as.character(GBAT_output_sub$GC_function[i]),".output")
	this_start <- GBAT_output_sub$GC_start[i]
	this_stop <- GBAT_output_sub$GC_end[i]
	this_name <- as.character(GBAT_output_sub$GC_fldname[i])
	out_df[,(this_name) := gsub(this_pat, this_rep, substr(get(this_fld), this_start, this_stop), perl=TRUE)]
  }	
  
  #remove space delimited output
  out_df[,c("F1A.output","F1E.output","FAP.output") := NULL]
  
  ###edit 03/22/2021: deal with misassignment of Marble Hill and Rikers Island borough codes###
  out_df[,F1E.key.lion_boro := ifelse(toupper(F1E.mh_ri_flag)=="M",'1',ifelse(toupper(F1E.mh_ri_flag)=="R",'2',F1E.key.lion_boro))]
  
  #get version
  out_df$GC.version <- "24b_24.2"

  return(rGBAT24B:::GBAT_census_format(out_df))
  
}


GBAT_3_df <- function(x, id_col, street1_col_name, street2_col_name, boro_code1_col_name, geocode_fields, boro_code2_col_name=NULL, com_dir_col_name=NULL) {

  if(is.null(com_dir_col_name)) com_dir_col_name=""	
  if(is.null(boro_code2_col_name)) boro_code2_col_name=""	

  ###convert to data.table###
  out_df <- as.data.table(rGBAT24B:::GBAT_3(x, id_col, street1_col_name, street2_col_name, boro_code1_col_name, boro_code2_col_name, com_dir_col_name))
  
  ###load meta data table for specific GBAT version###
  GBAT_o <- rGBAT24B::GBAT_output
  
  ###extract all output fields related to census geographies###
  cen_vec <- GBAT_o[grepl("\\.cen_blk|(\\.|_)cen_tract",GC_fldname) & GC_function %in% c("F2")]$GC_fldname
  
  ###added to deal with fields missing in earlier versions###
  cen_vec <- c(cen_vec,"F2.San1.sanborn_boro")
  
  GBAT_output_sub <- GBAT_o[GC_fldname %in% c(geocode_fields,cen_vec)]
  
  ###deal with illegal characters###
  out_df[,F2.output := as.character(F2.output)]
  Encoding(out_df$F2.output) <- "UTF-8"
  out_df$F2.output <- iconv(out_df$F2.output, "UTF-8", "UTF-8",sub='')
  
  
  #break output into fixed width columns
  for(i in 1:nrow(GBAT_output_sub)){
	this_pat <- ifelse(as.character(GBAT_output_sub$GC_fldname[i]) %in% cen_vec,"\\s","(?<=[\\s])\\s*|^\\s+|\\s+$")
	this_rep <- ifelse(as.character(GBAT_output_sub$GC_fldname[i]) %in% cen_vec,"0","")
	this_fld <- paste0(as.character(GBAT_output_sub$GC_function[i]),".output")
	this_start <- GBAT_output_sub$GC_start[i]
	this_stop <- GBAT_output_sub$GC_end[i]
	this_name <- as.character(GBAT_output_sub$GC_fldname[i])
	out_df[,(this_name) := gsub(this_pat, this_rep, substr(get(this_fld), this_start, this_stop), perl=TRUE)]
  }	
  
  #remove space delimited output
  out_df[,c("F2.output") := NULL]
  
  #get version
  out_df$GC.version <- "24b_24.2"

  return(rGBAT24B:::GBAT_census_format2(out_df))
  
}

################################
###NEW: BIN AND BBL FUNCTIONS###
################################
GBAT_BN_df <- function(x, id_col, bin_col, geocode_fields) {

  ###convert to data.table###
  out_df <- as.data.table(rGBAT24B:::GBAT_BN(x, id_col, bin_col))
  
  ###load meta data table for specific GBAT version###
  GBAT_o <- rGBAT24B::GBAT_output
  
  ###restrict output to user specified fields###
  GBAT_output_sub <- GBAT_o[GC_fldname %in% c(geocode_fields)]
  
  #break output into fixed width columns
  for(i in 1:nrow(GBAT_output_sub)){
	this_pat <- "(?<=[\\s])\\s*|^\\s+|\\s+$"
	this_rep <- ""
	this_fld <- paste0(as.character(GBAT_output_sub$GC_function[i]),".output")
	this_start <- GBAT_output_sub$GC_start[i]
	this_stop <- GBAT_output_sub$GC_end[i]
	this_name <- as.character(GBAT_output_sub$GC_fldname[i])
	out_df[,(this_name) := gsub(this_pat, this_rep, substr(get(this_fld), this_start, this_stop), perl=TRUE)]
  }	
  
  #remove space delimited output
  out_df[,c("FBN.output") := NULL]
  
  #get version
  out_df$GC.version <- "24b_24.2"

  return(out_df)
  
}

GBAT_BL_df <- function(x, id_col, bbl_col, geocode_fields) {

  ###convert to data.table###
  out_df <- as.data.table(rGBAT24B:::GBAT_BL(x, id_col, bbl_col))
  
  ###load meta data table for specific GBAT version###
  GBAT_o <- rGBAT24B::GBAT_output
  
  ###restrict output to user specified fields###
  GBAT_output_sub <- GBAT_o[GC_fldname %in% c(geocode_fields)]
  
  #break output into fixed width columns
  for(i in 1:nrow(GBAT_output_sub)){
	this_pat <- "(?<=[\\s])\\s*|^\\s+|\\s+$"
	this_rep <- ""
	this_fld <- paste0(as.character(GBAT_output_sub$GC_function[i]),".output")
	this_start <- GBAT_output_sub$GC_start[i]
	this_stop <- GBAT_output_sub$GC_end[i]
	this_name <- as.character(GBAT_output_sub$GC_fldname[i])
	out_df[,(this_name) := gsub(this_pat, this_rep, substr(get(this_fld), this_start, this_stop), perl=TRUE)]
  }	
  
  #remove space delimited output
  out_df[,c("FBL.output") := NULL]
  
  #get version
  out_df$GC.version <- "24b_24.2"

  return(out_df)
  
}


###wrapper function for census fields into USCB format
GBAT_census_format <- function(x) {

  GBAT_o <- rGBAT24B::GBAT_output

  #cb_fld <- "F1E.boro_of_cen_tract"
  
  cb_fld <- "F1E.key.lion_boro"
  
  ###added to deal with fields missing in earlier versions###
  cb_fld <- ifelse(cb_fld %in% colnames(x), cb_fld, "F1A.San.sanborn_boro") 
  
  cb_fld2 <- "F1E.FIPS_county"

  ###add FIPS formatted county code###		  
  x[,(cb_fld2) := ifelse(get(cb_fld)==1,'36061',
	ifelse(get(cb_fld)==2,'36005',
	  ifelse(get(cb_fld)==3,'36047',
		ifelse(get(cb_fld)==4,'36081',
		  ifelse(get(cb_fld)==5,'36085','00000')))))]	  
		  

  ###process census tract fields###		  
  ct_v <- GBAT_o[grepl("cen_tract_",GC_fldname) & GC_function %in% c("F1E","F1A","FAP"),]$GC_fldname

  for(i in 1:length(ct_v)){
	  x[,(paste0("F1E.USCB_tract_", gsub("F1E\\.cen_tract_","",ct_v[i]))) := paste0(as.character(get(cb_fld2)), as.character(get(ct_v[i])))]
  }

  ###process census block fields... sans suffix###
  cb_v <- GBAT_o[grepl("cen_blk_",GBAT_o$GC_fldname) & GC_function %in% c("F1E","F1A","FAP"),]$GC_fldname
  cb_v <- cb_v[!grepl("_sufx$",cb_v)]

  for(i in 1:length(cb_v)){
	x[,(paste0("F1E.USCB_block_", gsub("F1E\\.cen_blk_","",cb_v[i]))) := paste0(as.character(get(paste0("F1E.USCB_tract_", gsub("F1E\\.cen_blk_","",cb_v[i])))),as.character(get(cb_v[i])))]
  }

  return(x)
}

###wrapper function for census fields into USCB format
GBAT_census_format2 <- function(x) {

  GBAT_o <- rGBAT24B::GBAT_output

  cb_fld <- "F2.San1.sanborn_boro"
  
  cb_fld2 <- "F2.FIPS_county"

  ###add FIPS formatted county code###		  
  x[,(cb_fld2) := ifelse(get(cb_fld)==1,'36061',
	ifelse(get(cb_fld)==2,'36005',
	  ifelse(get(cb_fld)==3,'36047',
		ifelse(get(cb_fld)==4,'36081',
		  ifelse(get(cb_fld)==5,'36085','00000')))))]	  
		  

  ###process census tract fields###		  
  ct_v <- GBAT_o[grepl("cen_tract_",GC_fldname) & GC_function %in% c("F2"),]$GC_fldname

  for(i in 1:length(ct_v)){
	  x[,(paste0("F2.USCB_tract_", gsub("F2\\.cen_tract_","",ct_v[i]))) := paste0(as.character(get(cb_fld2)), as.character(get(ct_v[i])))]
  }

  return(x)
}

