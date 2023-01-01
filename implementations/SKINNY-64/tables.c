#define Order 1
#define RANDOM_LENGTH ((Order * Order + Order) * 4)


unsigned short random_table[RANDOM_LENGTH / 2];

unsigned short SKINNY_key0[Order]={0};
unsigned short SKINNY_key1[Order]={0};
unsigned short SKINNY_key2[Order]={0};
unsigned short SKINNY_key3[Order]={0};

unsigned short SKINNY_sbx0[Order]={0};
unsigned short SKINNY_sbx1[Order]={0};
unsigned short SKINNY_sbx2[Order]={0};
unsigned short SKINNY_sbx3[Order]={0};

unsigned short SKINNY_sby0[Order]={0};
unsigned short SKINNY_sby1[Order]={0};
unsigned short SKINNY_sby2[Order]={0};
unsigned short SKINNY_sby3[Order]={0};

unsigned short SKINNY_sbm0[Order]={0};
unsigned short SKINNY_sbm1[Order]={0};
unsigned short SKINNY_sbm2[Order]={0};
unsigned short SKINNY_sbm3[Order]={0};


unsigned short SKINNY_sband1tx0[Order];
unsigned short SKINNY_sband1tx1[Order];
unsigned short SKINNY_sband1tr[Order];
unsigned short SKINNY_sband2tx1[Order];
unsigned short SKINNY_sband2tx2[Order];
unsigned short SKINNY_sband2tr[Order];
unsigned short SKINNY_sband3tx2[Order];
unsigned short SKINNY_sband3ty0[Order];
unsigned short SKINNY_sband3tr[Order];
unsigned short SKINNY_sband4ty0[Order];
unsigned short SKINNY_sband4ty1[Order];
unsigned short SKINNY_sband4tr[Order];


unsigned short SKINNY_online_key0[1]={0};
unsigned short SKINNY_online_key1[1]={0};
unsigned short SKINNY_online_key2[1]={0};
unsigned short SKINNY_online_key3[1]={0};


unsigned short SKINNY_online_sbx0[1]={0};
unsigned short SKINNY_online_sbx1[1]={0};
unsigned short SKINNY_online_sbx2[1]={0};
unsigned short SKINNY_online_sbx3[1]={0};

unsigned short SKINNY_online_sbm0[1]={0};
unsigned short SKINNY_online_sbm1[1]={0};
unsigned short SKINNY_online_sbm2[1]={0};
unsigned short SKINNY_online_sbm3[1]={0};


unsigned short SKINNY_online_sby0[1]={0};
unsigned short SKINNY_online_sby1[1]={0};
unsigned short SKINNY_online_sby2[1]={0};
unsigned short SKINNY_online_sby3[1]={0};

unsigned short SKINNY_online_sbt1[1]={0};
unsigned short SKINNY_online_sbt2[1]={0};
unsigned short SKINNY_online_sbt3[1]={0};
unsigned short SKINNY_online_sbt4[1]={0};
unsigned short SKINNY_online_sbt5[1]={0};
unsigned short SKINNY_online_sbt6[1]={0};
unsigned short SKINNY_online_sbt7[1]={0};
unsigned short SKINNY_online_sbt8[1]={0};
unsigned short SKINNY_online_sbt9[1]={0};


unsigned short SKINNY_after_linear0[Order];
unsigned short SKINNY_after_linear1[Order];
unsigned short SKINNY_after_linear2[Order];
unsigned short SKINNY_after_linear3[Order];

unsigned short SKINNY_online_after_linear0[1];
unsigned short SKINNY_online_after_linear1[1];
unsigned short SKINNY_online_after_linear2[1];
unsigned short SKINNY_online_after_linear3[1];


unsigned char SKINNY_ART_constants_array[62] = {0x01,0x03,0x07,0x0F,0x1F,0x3E,0x3D,0x3B,0x37,0x2F,0x1E,0x3C,0x39,0x33,0x27,0x0E,0x1D,0x3A,0x35,0x2B,0x16,0x2C,0x18,0x30,0x21,0x02,0x05,0x0B,0x17,0x2E,0x1C,0x38,0x31,0x23,0x06,0x0D,0x1B,0x36,0x2D,0x1A,0x34,0x29,0x12,0x24,0x08,0x11,0x22,0x04,0x09,0x13,0x26,0x0C,0x19,0x32,0x25,0x0A,0x15,0x2A,0x14,0x28,0x10,0x20};

unsigned short SKINNY_after_shiftrows_sby0[Order];
unsigned short SKINNY_after_shiftrows_sby1[Order];
unsigned short SKINNY_after_shiftrows_sby2[Order];
unsigned short SKINNY_after_shiftrows_sby3[Order];
	
	
unsigned short SKINNY_online_after_shiftrows_sby0[1];
unsigned short SKINNY_online_after_shiftrows_sby1[1];
unsigned short SKINNY_online_after_shiftrows_sby2[1];
unsigned short SKINNY_online_after_shiftrows_sby3[1];
	
	
unsigned short SKINNY_after_mixcolumns_sby0[Order];
unsigned short SKINNY_after_mixcolumns_sby1[Order];
unsigned short SKINNY_after_mixcolumns_sby2[Order];
unsigned short SKINNY_after_mixcolumns_sby3[Order];
	
	
unsigned short SKINNY_online_after_mixcolumns_sby0[1];
unsigned short SKINNY_online_after_mixcolumns_sby1[1];
unsigned short SKINNY_online_after_mixcolumns_sby2[1];
unsigned short SKINNY_online_after_mixcolumns_sby3[1];