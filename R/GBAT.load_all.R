#helper function to load all available versions of rGBAT supporting packages and returns names of said packages

GBAT.load_all <- function(){

	###check where this package is loaded... used for testing purposes when loaded in local libpath###
	my_loc <- gsub("/rGBAT","",find.package("rGBAT"))
	
	#cat(my_loc)
	
	#my_loc <- "/home/health.dohmh.nycnet/gculp/R/x86_64-redhat-linux-gnu-library/3.3"

	###check for installed packages###
	###from: https://www.r-bloggers.com/list-of-user-installed-r-packages-and-their-versions/###
	ip <- as.data.frame(installed.packages(my_loc)[,c(1,3:4)])
	rownames(ip) <- NULL
	ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]
	gc.pks <- ip[grepl("^rGBAT[[:digit:]]{1,}",ip$Package),]
	
	gc.pks$Release <- gsub("rGBAT","",as.character(gc.pks$Package))
	
	rownames(gc.pks) <- 1:nrow(gc.pks)
	
	###unload rGBAT installed packages just in case they are in a different libpath from rGBAT wrapper###
	invisible(lapply((.packages())[(.packages()) %in% as.character(gc.pks$Package)], function(k) detach( paste('package:', k, sep='', collapse=''), unload=TRUE, char=TRUE)))
	
	###unload namespaces###
	invisible(suppressMessages(lapply(as.character(gc.pks$Package), unloadNamespace)))
	
	###silently load all installed rGBAT packages###
	invisible(suppressMessages(lapply(as.character(gc.pks$Package), require, character.only = TRUE, lib.loc = my_loc)))
	
	return(gc.pks)
	
}