

###construct vector of package names###
packages <- c("Rcpp","withr","devtools","roxygen2","data.table","RCurl")

###if packages are absent from library, install them###
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
	install.packages(setdiff(packages, rownames(installed.packages()))) 
}

###load packages###
suppressMessages(lapply(packages, require, character.only = TRUE))

################
###unzip file###
################

###path of zip file###
zip_path <- "rGBAT-temp_packages.zip" ## This is the file relative to the root of the git repo

#tmpdir <- tempdir() ## trying to do this in tempdir is breaking things, 
	# instead, let't put the files in home:
	tmpdir <- Sys.getenv("HOME")


unzip(zip_path, exdir = tmpdir)

###the file path where you unzipped the package source###
pkg.path <- file.path(tmpdir,"temp_packages")

v.y <- list.files(pkg.path)
v.x <- c("rGBAT","rGBAT20B")

###check that the deisred packages are included in the unzipped file###
if(any(apply(embed(v.y,length(v.y)-length(v.x)+1),2,identical,v.x))){

	###view all package paths###
	#.libPaths()

	###the file path where you wish to install your package###
	this.libPath <- .libPaths()[1]

	###if old version of package is installed, remove it###
	ip <- as.character(installed.packages(this.libPath)[,'Package'])

	pkg.name <- "rGBAT20B"
	
	if (pkg.name %in% ip){
		remove.packages(pkg.name, lib=this.libPath)
	}
	
	pkg.path2 <- file.path(pkg.path,pkg.name)
	
	###compile package with Rcpp###
	Rcpp::compileAttributes(pkgdir = pkg.path2, verbose=TRUE)

	###generate documentation with devtools###
	devtools::document(pkg=pkg.path2)

	###detach package from memory so it can be installed###
	detach(paste0("package:",pkg.name), character.only = TRUE, unload = TRUE)

	###install package###
	withr::with_libpaths(new = this.libPath, devtools::install_local(pkg.path2, force = TRUE, dependencies=FALSE, INSTALL_opts="--no-multiarch"))

	#
	##
	###
	##
	#
	
	pkg.name <- "rGBAT"
	
	if (pkg.name %in% ip){
		remove.packages(pkg.name, lib=this.libPath)
	}

	pkg.path2 <- file.path(pkg.path,pkg.name)

	###generate documentation with devtools###
	devtools::document(pkg=pkg.path2)

	###detach package from memory so it can be installed###
	detach(paste0("package:",pkg.name), character.only = TRUE, unload = TRUE)

	###install package###               
	withr::with_libpaths(new = this.libPath, devtools::install_local(pkg.path2, force = TRUE, dependencies=FALSE))

} else{

	cat("There is an issue with package installation!")
}






