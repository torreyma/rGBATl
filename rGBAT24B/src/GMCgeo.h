#ifndef NYCgeoH
#define NYCgeoH

#ifdef __cplusplus
extern "C" {
#endif

#ifdef WIN32
void ROLE geo(char *ptr_wa1, char *ptr_wa2);
#elif defined (__linux__)
extern void geo(char *ptr_wa1, char *ptr_wa2);
#endif

#ifdef __cplusplus
}
#endif
#endif
