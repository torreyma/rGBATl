
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

DataFrame GBAT_3(DataFrame x, std::string id_col, std::string street_name1, std::string street_name2, std::string boro_code1, std::string boro_code2="", std::string compass_dir="") {

  //setenv("GEOFILES", "/home/dynohub/version-24b_24.2/fls/", 1); // Overwrite it
  // Get HOME environment variable:
  std::string home_path = getenv("HOME");
  // Construct GEOFILES env variable string:
  std::string geo_path = "GEOFILES=" + home_path + "/version-24b_24.2/fls/";
  // convert to C-style string for putenv:
  const char* cgeo_path = geo_path.c_str();
  // Set GEOFILES variable 
  putenv(const_cast<char*>(cgeo_path)); // use putenv instead of setenv because it will work on msys2 on Windows

  //preparations for output data frame
  //int n_col = 4;
  //CharacterVector col_names (4);
  
  std::vector<std::string> col_names (4);
  
  
  //get values from data frame
  CharacterVector id_vec = x[id_col];
  col_names[0] = id_col;
  
  CharacterVector street_name1_vec = x[street_name1];
  col_names[1] = street_name1;
  
  CharacterVector street_name2_vec = x[street_name2];
  col_names[2] = street_name2;
  
  CharacterVector boro_code1_vec = x[boro_code1];
  col_names[3] = boro_code1;
  
  
  //optional argument 1: second borough code
  CharacterVector boro_code2_vec (id_vec.size());
  
  if (boro_code2[0] != '\0') {	  
	boro_code2_vec = x[boro_code2];  
	
	col_names.resize(col_names.size() + 1);
	col_names[col_names.size() - 1] = boro_code2;
  } 
  
  //optional argument 2: compass direction	  
  CharacterVector compass_dir_vec (id_vec.size()); 	  
	  
  if (compass_dir[0] != '\0') {	  
	compass_dir_vec = x[compass_dir]; 
	
	col_names.resize(col_names.size() + 1);
	col_names[col_names.size() - 1] = compass_dir;
  } 
  
  // create new variables for export
  std::vector<std::string> all_vars_f2 (id_vec.size());
  
  
  //loop through addresses	
  for (int i = 0; i < id_vec.size() ; i++) {

    //input for function 2
    union {  
      C_WA1 wa1; 
      char cwa1[sizeof(C_WA1)]; 
    } uwa1; 

    //output for function 2
    union { 
      C_WA2_F2 wa2_f2; 
      char cwa2_f2[sizeof(C_WA2_F2)]; 
    } uwa2_f2; 
	
    //using function 2
    memset(uwa1.cwa1, ' ', sizeof(C_WA1)); 
	uwa1.wa1.input.func_code[0] = '2';
    uwa1.wa1.input.platform_ind = 'C'; 

	//reading street name 1 contents
    std::string in_stname1_str = Rcpp::as<std::string>(street_name1_vec[i]);
    char *in_stname1 = new char[in_stname1_str.length() + 1];
    std::strcpy(in_stname1, in_stname1_str.c_str());
	
	memcpy(uwa1.wa1.input.sti[0].Street_name, in_stname1, strlen(in_stname1));
    delete[] in_stname1;
	
	
	//reading street name 2 contents
    std::string in_stname2_str = Rcpp::as<std::string>(street_name2_vec[i]);
    char *in_stname2 = new char[in_stname2_str.length() + 1];
    std::strcpy(in_stname2, in_stname2_str.c_str());
	
	memcpy(uwa1.wa1.input.sti[1].Street_name, in_stname2, strlen(in_stname2));
    delete[] in_stname2;
	
	//reading borough code 1 column contents
    std::string boro_code1_str = Rcpp::as<std::string>(boro_code1_vec[i]);
    char *in_boro1 = new char[boro_code1_str.length() + 1];
    std::strcpy(in_boro1, boro_code1_str.c_str());
	
	uwa1.wa1.input.sti[0].boro = in_boro1[0];
	delete[] in_boro1;
	
	
	if (boro_code2[0] != '\0') {
	
		//reading borough code 2 column contents
		std::string boro_code2_str = Rcpp::as<std::string>(boro_code2_vec[i]);
		
		char *in_boro2 = new char[boro_code2_str.length() + 1];
		std::strcpy(in_boro2, boro_code2_str.c_str());
		
		uwa1.wa1.input.sti[1].boro = in_boro2[0];
		delete[] in_boro2;
		
	}
	
	if (compass_dir[0] != '\0') {
	
		//reading compass direction column contents
		std::string compass_dir_str = Rcpp::as<std::string>(compass_dir_vec[i]);
		
		char *comp_dir = new char[compass_dir_str.length() + 1];
		std::strcpy(comp_dir, compass_dir_str.c_str());
		uwa1.wa1.input.comp_direction = comp_dir[0];
		delete[] comp_dir;	
	
	}
	

	//call function 2
    geo(uwa1.cwa1, uwa2_f2.cwa2_f2); 
	
	
    //all variables for function 2
    std::string all_wa1_var_in; 
    all_wa1_var_in = uwa1.cwa1; 
	all_wa1_var_in.resize (sizeof(C_WA1));
	
	std::string all_wa1_var; 
    all_wa1_var = uwa2_f2.cwa2_f2; 
	all_wa1_var.resize (sizeof(C_WA2_F2));
    all_vars_f2[i] = all_wa1_var_in + all_wa1_var;
	
  }

  
  //variable number of columns based on input arguments
  Rcpp::List temp_list(col_names.size() + 1);
  
  for (std::size_t i = 0, max = col_names.size(); i != max; ++i) {
  //for (int i = 0; i < col_names.size() ; i++) {
	temp_list[i] = x[col_names[i]];
  }
  
  //add output to list
  col_names.resize(col_names.size() + 1);
  col_names[col_names.size() - 1] = "F2.output";
  temp_list[col_names.size() - 1] = all_vars_f2;
  
  Rcpp::DataFrame result(temp_list);
  result.attr("names") = col_names;
  return result;
  			  
}
