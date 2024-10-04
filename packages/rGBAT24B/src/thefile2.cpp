
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
DataFrame GBAT_2(DataFrame x, std::string id_col, std::string hse_num_col, std::string add_col, std::string third_col, std::string third_col_type = "boro_code", std::string unit_col = "") {
	
  //setenv("GEOFILES", "/home/dynohub/version-24b_24.2/fls/", 1); // Overwrite it
  // Get HOME environment variable:
  std::string home_path = getenv("HOME");
  // Construct GEOFILES env variable string:
  std::string geo_path = "GEOFILES=" + home_path + "/version-24b_24.2/fls/";
  // convert to C-style string for putenv:
  const char* cgeo_path = geo_path.c_str();
  // Set GEOFILES variable 
  putenv(const_cast<char*>(cgeo_path)); // use putenv instead of setenv because it will work on msys2 on Windows

  std::vector<std::string> col_names (4);
  
  CharacterVector id_vec = x[id_col];
  col_names[0] = id_col;
  
  CharacterVector hse_num_vec = x[hse_num_col];
  col_names[1] = hse_num_col;
  
  CharacterVector add_vec = x[add_col];
  col_names[2] = add_col;
  
  CharacterVector third_vec = x[third_col];
  col_names[3] = third_col;
  
  //optional argument: unit	  
  CharacterVector unit_vec (id_vec.size()); 
  
  if (unit_col[0] != '\0') {	  
	unit_vec = x[unit_col]; 
	
	col_names.resize(col_names.size() + 1);
	col_names[col_names.size() - 1] = unit_col;
  } 
  
  
  // create new variables for export
  std::vector<std::string> all_varsAP (id_vec.size()); // FAP
  std::vector<std::string> all_vars1A (id_vec.size());
  std::vector<std::string> all_vars1E (id_vec.size());
  

  for (int i = 0; i < id_vec.size() ; i++) {

    //input for function AP
    union {  // FAP
      C_WA1 wa1_ap; // FAP
      char cwa1_ap[sizeof(C_WA1)]; // FAP
    } uwa1_ap; // FAP

    //input for function 1A
    union {
      C_WA1 wa1_1a;
      char cwa1_1a[sizeof(C_WA1)];
    } uwa1_1a;

    //input for function 1E
    union {
      C_WA1 wa1_1e;
      char cwa1_1e[sizeof(C_WA1)];
    } uwa1_1e;

    //output for function AP
    union { // FAP
      C_WA2_FAPX wa2_fapx; // FAP
      char cwa2fapx[sizeof(C_WA2_FAPX)]; // FAP
    } uwa2fapx; // FAP
	
    //output for function 1A
    union {
      C_WA2_F1AX wa2_f1ax;
      char cwa2f1ax[sizeof(C_WA2_F1AX)];
    } uwa2f1ax;

    //output for function 1E
    union {
      C_WA2_F1EX wa2_f1ex;
      char cwa2f1ex[sizeof(C_WA2_F1EX)];
    } uwa2f1ex;


    //using function AP
    memset(uwa1_ap.cwa1_ap, ' ', sizeof(C_WA1)); // FAP
    memcpy(uwa1_ap.wa1_ap.input.func_code, "AP", 2); // FAP
    uwa1_ap.wa1_ap.input.platform_ind = 'C'; // FAP

    //using function 1A
    memset(uwa1_1a.cwa1_1a, ' ', sizeof(C_WA1));
    memcpy(uwa1_1a.wa1_1a.input.func_code, "1A", 2);
    uwa1_1a.wa1_1a.input.platform_ind = 'C';

    //using function 1E
    memset(uwa1_1e.cwa1_1e, ' ', sizeof(C_WA1));
    memcpy(uwa1_1e.wa1_1e.input.func_code, "1E", 2);
    uwa1_1e.wa1_1e.input.platform_ind = 'C';

    std::string in_third_str = Rcpp::as<std::string>(third_vec[i]);
    char *in_third = new char[in_third_str.length() + 1];
    std::strcpy(in_third, in_third_str.c_str());

    //check third column and assign accordingly
    if (third_col_type=="zip_code") {
      //zip code
      memcpy(uwa1_ap.wa1_ap.input.zipin, in_third, strlen(in_third)); // FAP
      memcpy(uwa1_1a.wa1_1a.input.zipin, in_third, strlen(in_third));
      memcpy(uwa1_1e.wa1_1e.input.zipin, in_third, strlen(in_third));
    }
    else {
      //borough code
      uwa1_ap.wa1_ap.input.sti[0].boro = in_third[0]; // FAP
      uwa1_1a.wa1_1a.input.sti[0].boro = in_third[0];
      uwa1_1e.wa1_1e.input.sti[0].boro = in_third[0];
    }
    delete[] in_third;


    //freeform address if house number is missing OR street name if house number is present
    std::string in_stname_str = Rcpp::as<std::string>(add_vec[i]);
    char *in_stname = new char[in_stname_str.length() + 1];
    std::strcpy(in_stname, in_stname_str.c_str());
    
	memcpy(uwa1_ap.wa1_ap.input.sti[0].Street_name, in_stname, strlen(in_stname)); // FAP
    memcpy(uwa1_1a.wa1_1a.input.sti[0].Street_name, in_stname, strlen(in_stname));
    memcpy(uwa1_1e.wa1_1e.input.sti[0].Street_name, in_stname, strlen(in_stname));
    delete[] in_stname;
	
	
	std::string in_hse_num_str = Rcpp::as<std::string>(hse_num_vec[i]);
	char *in_hse_num = new char[in_hse_num_str.length() + 1];
	std::strcpy(in_hse_num, in_hse_num_str.c_str());
	
	memcpy(uwa1_ap.wa1_ap.input.hse_nbr_disp, in_hse_num, strlen(in_hse_num)); // FAP
	memcpy(uwa1_1a.wa1_1a.input.hse_nbr_disp, in_hse_num, strlen(in_hse_num));
	memcpy(uwa1_1e.wa1_1e.input.hse_nbr_disp, in_hse_num, strlen(in_hse_num));
	delete[] in_hse_num;
	
	//NEW: add unit field
	if (unit_col[0] != '\0') {
		std::string in_unit_str = Rcpp::as<std::string>(unit_vec[i]);
		
		char *in_unit = new char[in_unit_str.length() + 1];
		std::strcpy(in_unit, in_unit_str.c_str());
		
		memcpy(uwa1_ap.wa1_ap.input.unit, in_unit, strlen(in_unit)); // FAP
		memcpy(uwa1_1a.wa1_1a.input.unit, in_unit, strlen(in_unit));
		memcpy(uwa1_1e.wa1_1e.input.unit, in_unit, strlen(in_unit));
		delete[] in_unit;
	}
	
    //geocoding functions with extended work area

    //call extended function AP
    uwa1_ap.wa1_ap.input.mode_switch = 'X'; // FAP
    geo(uwa1_ap.cwa1_ap, uwa2fapx.cwa2fapx); // FAP

    //call extended function 1A
    uwa1_1a.wa1_1a.input.mode_switch = 'X';
    geo(uwa1_1a.cwa1_1a, uwa2f1ax.cwa2f1ax);

    //call extended function 1E
    uwa1_1e.wa1_1e.input.mode_switch = 'X';
    geo(uwa1_1e.cwa1_1e, uwa2f1ex.cwa2f1ex);

    //all variables for function AP
    std::string all_wa1_ap_var; // FAP
    all_wa1_ap_var = uwa2fapx.cwa2fapx; // FAP
	all_wa1_ap_var.resize (sizeof(C_WA2_FAPX)); // FAP
    all_varsAP[i] = all_wa1_ap_var; // FAP

    //all variables for function 1A
    std::string all_wa1_1a_var;
    all_wa1_1a_var = uwa2f1ax.cwa2f1ax;
	all_wa1_1a_var.resize (sizeof(C_WA2_F1AX));
    all_vars1A[i] = all_wa1_1a_var;

    //all variables for function 1E
    std::string all_wa1_1e_var;
    all_wa1_1e_var = uwa1_1e.cwa1_1e;
	all_wa1_1e_var.resize (sizeof(C_WA1) + sizeof(C_WA2_F1EX));
    all_vars1E[i] = all_wa1_1e_var;

  }

  //unsetenv("GEOFILES");
  
  //variable number of columns based on input arguments
  Rcpp::List temp_list(col_names.size() + 3);
  
  for (std::size_t i = 0, max = col_names.size(); i != max; ++i) {
	temp_list[i] = x[col_names[i]];
  }
	
  //add output to list
  col_names.resize(col_names.size() + 1);
  col_names[col_names.size() - 1] = "FAP.output";
  temp_list[col_names.size() - 1] = all_varsAP;
  
  col_names.resize(col_names.size() + 1);
  col_names[col_names.size() - 1] = "F1A.output";
  temp_list[col_names.size() - 1] = all_vars1A;
  
  col_names.resize(col_names.size() + 1);
  col_names[col_names.size() - 1] = "F1E.output";
  temp_list[col_names.size() - 1] = all_vars1E;
  
  Rcpp::DataFrame result(temp_list);
  result.attr("names") = col_names;
  return result;		 
   			  
}
