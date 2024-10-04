#' @description The \code{USCB.process_freeform_addresses} function allows the user to geocode a data frames of freeform US addresses where house number and street name are together in one column.  It aggregates duplicate records, geocodes using the US Census Bureau batch geocoding service, and then merges the geocoded results back to the original data frame. 
#'
#' @details For more information, refer to the \href{https://www.census.gov/geo/maps-data/data/geocoder.html}{Census Geocoder webpage}.
#' @title Geocode a data frame of freeform US addresses with the USCB batch geocoding service.
#' @name USCB.process_freeform_addresses
#' @aliases USCB.process_freeform_addresses
#' @import httr
#' @import jsonlite
#' @import data.table
#' @export USCB.process_freeform_addresses
#' @param in_df a data frame or data table containing US addresses.  Required.
#' @param addr_col_name the name of the input addresses column as string.  Required.
#' @param city_col_name the name of the input city column as string.  Required.
#' @param state_col_name the name of the input state column as string.  Required.
#' @param zipcode_col_name the name of the input zip code column as string.  Required.
#' @param rec_num number of records to process with each hit to the geocoding service. Optional.
#' @usage USCB.process_freeform_addresses(in_df, addr_col_name,  
#'     city_col_name, state_col_name, zipcode_col_name, 
#'     rec_num = 10000)
#' @return A data frame or data table (depending on input class) containing the original data frame plus the geocoder return fields which include: block, tract, PUMA, TigerLine, coordinates and matching information for 2000, 2010, and current geographic vintages.
#' @examples #create a data frame of addresses
#' #we'll use the NYC OpenData Restaurant Inspections API
#' URL <- "https://data.cityofnewyork.us/resource/43nn-pn8j.json"
#' str1 <- "$where=(inspection_date>='2019-01-01')"
#' str2 <- "$group=camis,dba,building,street,boro,zipcode"
#' str3 <- "$select=camis,dba,building,street,boro,zipcode"
#' str4 <- "$limit=20000"
#' data_URL <- paste0(URL,"?",str1,"&",str2,"&",str3,"&",str4)
#' con <- url(URLencode(data_URL))
#' data_JSON <- jsonlite::fromJSON(con)
#' data_JSON$ADDR <- paste(data_JSON$building, data_JSON$street, sep=" ")
#' data_JSON$STATE <- "NY"
#'  
#' #test batch process speed
#' test.df1 <- data_JSON[1:100,]
#' ptm <- proc.time()
#' GEO_df2a <- USCB.process_freeform_addresses(test.df1, "ADDR", "boro", 
#'   "STATE", "zipcode", 10)
#' proc.time() - ptm
#' 
#' #preview results
#' head(GEO_df2a)

USCB.process_freeform_addresses <- function(in_df, addr_col_name, city_col_name, state_col_name, zipcode_col_name, rec_num){
	
	###end function if in_df not data.frame or data.table###
	if(!("data.frame" %in% class(in_df))) stop("You must supply a valid data.frame or data.table!")
	
	###detect if data.table or data.frame###
	is.DT <- "data.table" %in% class(in_df)
	
	###if data.frame, convert to data.table###
	if(!is.DT) in_df <- as.data.table(in_df)
	
	###end function if columns are absent###
	if(length(unique(c(addr_col_name, city_col_name, state_col_name, zipcode_col_name))[unique(c(addr_col_name, city_col_name, state_col_name, zipcode_col_name)) %in% names(in_df)]) != 4) stop("You have entered invalid column names!")
	
	###deal with commas and errant spaces in the address fields###
	col_vec <- c("new_addr_col", city_col_name, state_col_name, zipcode_col_name)
	in_df[,new_addr_col := gsub(","," ", as.character(get(addr_col_name)))]
	in_df[,(col_vec):= lapply(.SD, function(x) gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "",as.character(x), perl=TRUE)), .SDcols = col_vec]
	
	#aggregate duplicate addresses
	df_unq <- unique(in_df[,col_vec,with=FALSE])
	
	#add unique id
	df_unq[,u_id := .I]
	
	###optimal number of records to prevent bloat###
	rec_num <- ifelse(rec_num <= 10000, rec_num, 10000)
	df_unq[,pl := rep(1:ceiling(nrow(df_unq)/rec_num),each=rec_num)[1:nrow(df_unq)]]
				
			
	census.df <- data.table::rbindlist(lapply(1:max(df_unq$pl), function(yy) {
		###data chunk###
		sub_df <- df_unq[pl==yy, c("u_id", "new_addr_col", city_col_name, state_col_name, zipcode_col_name),with=FALSE]
		
		###get 2000 census tracts### 
		temp.df.A <- as.data.table(GEO_census_batch(sub_df,"Public_AR_Census2010","Census2000_Census2010"))
		setnames(temp.df.A,names(temp.df.A),paste0('V', seq_len(ncol(temp.df.A)),'A'))
		
		###get 2010 census tracts### 
		temp.df.B <- as.data.table(GEO_census_batch(sub_df,"Public_AR_Census2010","Census2010_Census2010"))
		setnames(temp.df.B, names(temp.df.B),paste0('V', seq_len(ncol(temp.df.B)),'B'))
		
		###get current census tracts### 
		temp.df.C <- as.data.table(GEO_census_batch(sub_df,"Public_AR_Current","Current_Current"))
		setnames(temp.df.C,names(temp.df.C),paste0('V', seq_len(ncol(temp.df.C)),'C'))
		
		temp.df <- merge(temp.df.A, temp.df.B, by.x="V1A", by.y="V1B")
		
		temp.df <- merge(temp.df, temp.df.C, by.x="V1A", by.y="V1C")		
		
		###run garbage collector###
		invisible(gc())
		
		return(temp.df)
	}), use.names=TRUE, fill=TRUE)
			
	###format and date census geographies###
	census.df[,CB_2000 := gsub("[[:space:]]", "",paste0(V16A,V17A,V18A,V19A))]
	census.df[,CB_2010 := gsub("[[:space:]]", "",paste0(V16B,V17B,V18B,V19B))]
	census.df[,CB_Current := gsub("[[:space:]]", "",paste0(V16C,V17C,V18C,V19C))]
	census.df[,CT_2000 := gsub("[[:space:]]", "",paste0(V16A,V17A,V18A))]
	census.df[,CT_2010 := gsub("[[:space:]]", "",paste0(V16B,V17B,V18B))]
	census.df[,CT_Current := gsub("[[:space:]]", "",paste0(V16C,V17C,V18C))]
	
	census.df <- census.df[,c(paste0("V",c(1:7,12:14),"A"),"CB_2000","CT_2000",paste0("V",c(6:7,12:14),"B"),"CB_2010","CT_2010",paste0("V",c(6:7,12:14),"C"),"CB_Current","CT_Current"),with=FALSE]
	
	setnames(census.df,names(census.df),c("u_id", "new_addr_col", city_col_name, state_col_name, zipcode_col_name, "match_status_2000", "match_type_2000", "longitude_2000"," latitude_2000","TigerLine_2000","CB_2000","CT_2000","match_status_2010", "match_type_2010", "longitude_2010"," latitude_2010","TigerLine_2010","CB_2010","CT_2010","match_status_Current", "match_type_Current", "longitude_Current"," latitude_Current","TigerLine_Current","CB_Current","CT_Current"))
	
	#load("/home/health.dohmh.nycnet/gculp/build_packages/rGBAT/data/US_CB_PUMA_2000.rda")
	#load("/home/health.dohmh.nycnet/gculp/build_packages/rGBAT/data/US_CT_PUMA_2010.rda")
	
	census.df <- merge(census.df,US_CB_PUMA_2000,by="CB_2000",all.x=TRUE)
	census.df <- merge(census.df,US_CT_PUMA_2010,by="CT_2010",all.x=TRUE)
	census.df <- merge(census.df,US_CT_PUMA_2010,by.x="CT_Current",by.y="CT_2010",all.x=TRUE)
	setnames(census.df,c("PUMA_2010.x","PUMA_2010.y"),c("PUMA_2010","PUMA_Current"))
	census.df[is.na(census.df)] <- ""
	
	#join back to original
	census.df[,(col_vec):= lapply(.SD, as.character), .SDcols = col_vec]
	census.df[,(col_vec):= lapply(.SD, function(x) trimws(x)), .SDcols = col_vec]
	
	census.df <- merge(in_df, census.df, by=col_vec, all.x=TRUE)
	census.df[,c('new_addr_col','u_id') := NULL]
	
	#if input was a data.frame, return to that state
	if(!is.DT) census.df <- as.data.frame(census.df)
	
	return(census.df)
}


