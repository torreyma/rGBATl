
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
//#include <NYCgeo.h>
#include <pac.h>
#include <cstring>
#include <cstdlib>

// [[Rcpp::export]]
DataFrame GBAT_BN(DataFrame x, std::string id_col, std::string bin_col) {

  //setenv("GEOFILES", "/home/dynohub/version-24b_24.2/fls/", 1); // Overwrite it
  // Get HOME environment variable:
  std::string home_path = getenv("HOME");
  // Construct GEOFILES env variable string:
  std::string geo_path = "GEOFILES=" + home_path + "/version-24b_24.2/fls/";
  // convert to C-style string for putenv:
  const char* cgeo_path = geo_path.c_str();
  // Set GEOFILES variable 
  putenv(const_cast<char*>(cgeo_path)); // use putenv instead of setenv because it will work on msys2 on Windows

  CharacterVector id_vec = x[id_col];
  
  CharacterVector bin_vec = x[bin_col];
  
  // create new variables for export
  std::vector<std::string> all_varsBN (id_vec.size()); 
  
  for (int i = 0; i < id_vec.size() ; i++) {
  
    union {
      C_WA1 wa1;
      char cwa1[sizeof(C_WA1)];
    } uwa1;
	
	union {
        C_WA2_F1AX wa2_f1ax;
        char cwa2f1ax[sizeof(C_WA2_F1AX)];
      } uwa2f1ax;
	
	memset(uwa1.cwa1, ' ', sizeof(C_WA1));
	memcpy(uwa1.wa1.input.func_code, "BN", 2);
	uwa1.wa1.input.platform_ind = 'C';
	
	//enter BIN
	std::string in_bin_str = Rcpp::as<std::string>(bin_vec[i]);
    char *in_bin = new char[in_bin_str.length() + 1];
    std::strcpy(in_bin, in_bin_str.c_str());
	
	memcpy(uwa1.wa1.input.bld_id, in_bin, strlen(in_bin)); 
	
    delete[] in_bin;
	
	//set return TPAD data
	uwa1.wa1.input.tpad_switch = 'Y';
	
	//set return extended work area
	uwa1.wa1.input.mode_switch = 'X';
	
	//call function
    geo(uwa1.cwa1, uwa2f1ax.cwa2f1ax);
	
	
	//all variables for function 1a
    std::string all_wa1_var_in; 
    all_wa1_var_in = uwa1.cwa1; 
	all_wa1_var_in.resize (sizeof(C_WA1));
	
	std::string all_wa2_var_out; 
    all_wa2_var_out = uwa2f1ax.cwa2f1ax; 
	all_wa2_var_out.resize (sizeof(C_WA2_F1AX));
	
	all_varsBN[i] = all_wa2_var_out;
	
  }


  return Rcpp::DataFrame::create( Named(id_col)= id_vec
	, Named(bin_col)= bin_vec
	, Named("FBN.output") = all_varsBN);
				  
}
  
  
