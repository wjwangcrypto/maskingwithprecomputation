
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>


int main(void)
{
	char a = asmprecom();
	char c = shiftrows_precompute();
	char b = mixcolumns_precompute();
	char d = asmonline();
	char e = shiftrows_online();
	char f = mixcolumns_online();

}