##################################################################
###Census Batch Geocoding API helper function, max 1000 records###
##################################################################


GEO_census_batch <- function(addresses,benchmark,vintage){	

	set_config( config( ssl_verifypeer = 0L ) )
	
	###extend timeout###
	set_config(timeout(seconds = 2000))
	
	my_proxy <- "healthproxy.health.dohmh.nycnet"
	
    options(unzip = 'internal')
	
	apiurl <- "https://geocoding.geo.census.gov/geocoder/geographies/addressbatch"
	
	file <- tempfile(fileext = ".csv")
	
	write.table(addresses, file, sep=",", col.names = FALSE, row.names = FALSE) 
	
	ptm <- proc.time()
	req <- POST(apiurl, body=list(
		addressFile = upload_file(file), 
		benchmark = benchmark,
		vintage = vintage
	), 
	encode="multipart"
	)
	
	ptm2 <- proc.time() - ptm
	
	test <- content(req, as = "text", encoding = "UTF-8")
	test1 <- gsub("\"", "", test)
	test1a <- unlist(strsplit(test1, split="\n"))
	
	###deal with failed records which have missing return fields###
	fld_tot <- lengths(regmatches(test1a, gregexpr(",", test1a)))
	max_cnt <- max(max(fld_tot),18)
	fld_dif <- as.numeric(max_cnt - fld_tot)
	test2 <- paste0(test1a, strrep(", ", fld_dif))
	
	splitdat = do.call("rbind", strsplit(test2, ","))
	
	splitdat = data.frame(apply(splitdat, 2, as.character))
	names(splitdat) = paste("field", 1:length(splitdat), sep = "_")
	
	#delete temp file
	on.exit(unlink(file))
	
	return(splitdat)
}
