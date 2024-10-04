
#include <Rcpp.h>

using namespace Rcpp;

#if defined(WIN32)
#define ROLE __declspec(dllimport) __stdcall
#elif defined(x64)
#define ROLE __declspec(dllimport) __stdcall
#elif defined(__linux__)
#define ROLE __stdcall
#endif

#include <GMCgeo.h>
#include <pac.h>
#include <cstring>
#include <cstdlib> // for putenv
#include <string> // needed for std::string

// [[Rcpp::export]]
std::string HR() {
	
	//setenv("GEOFILES", "/home/dynohub/version-24b_24.2/fls/", 1); // Overwrite it
	// Get HOME environment variable:
	std::string home_path = getenv("HOME");
	// Construct GEOFILES env variable string:
	std::string geo_path = "GEOFILES=" + home_path + "/version-24b_24.2/fls/";
	// convert to C-style string for putenv:
        const char* cgeo_path = geo_path.c_str();
	// Set GEOFILES variable 
	putenv(const_cast<char*>(cgeo_path)); // use putenv instead of setenv because it will work on msys2 on Windows

	union {
        C_WA1 wa1;
        char cwa1[sizeof(C_WA1)];
      } uwa1;
	  
	char cwa2fhr[5000];
	 
    memset(uwa1.cwa1, ' ', sizeof(C_WA1));
	memcpy(uwa1.wa1.input.func_code, "HR", 2);
	uwa1.wa1.input.platform_ind = 'C';
	
	
	memcpy(uwa1.wa1.input.zipin, "10013", 5);
	memcpy(uwa1.wa1.input.hse_nbr_disp, "125", 3); 
	memcpy(uwa1.wa1.input.sti[0].Street_name, "WORTH STREET", 12); 

	geo(uwa1.cwa1, cwa2fhr);

	std::string xxx;
    xxx = cwa2fhr;
	//std::string xxx2 = xxx.substr (14,4);
	std::string xxx2 = xxx.substr (0,50);
	
	return xxx2;
	
}





