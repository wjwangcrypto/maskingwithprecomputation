#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>




int main(void)
{
	char k = SKINNY_asmprecom();
	char l = SKINNY_AC_precompute();
	char m = SKINNY_ART_precompute();
	char n = SKINNY_shiftrows_precompute();
	char o = SKINNY_mixcolumns_precompute();
	char p = SKINNY_asmonline();
	char q = SKINNY_AC_online();
	char r = SKINNY_ART_online();
	char s = SKINNY_shiftrows_online();
	char t = SKINNY_mixcolumns_online();
  
  return 0;

}




















