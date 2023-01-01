`include "custom_cells.v"			// Should be commented out in yosys.

module Mul4(
	input clk,
	input[4:0] x,
	input[4:0] y,
	input[3:0] r,
	output[4:0] z);

	wire u_1,s_1,t_1, u_2,s_2,t_2, u_3,s_3,t_3, u_4,s_4,t_4;

	// Mul2
	AND u29_AND(x[0],y[0],u_1);
	AND u30_AND(x[1],y[1],u_2);
	AND u31_AND(x[2],y[2],u_3);
	AND u32_AND(x[3],y[3],u_4);

	// / ri
	wire r_1_1,r_1_2,r_1_3,r_1_4;
	XOR u11_XOR(r[0],u_1,r_1_1);
	XOR u12_XOR(r[1],u_2,r_1_2);
	XOR u13_XOR(r[2],u_3,r_1_3);
	XOR u14_XOR(r[3],u_4,r_1_4);

	// / si
	wire s_1_1,s_1_2;
	XOR u21_XOR(x[0],r_1_1,s_1_1);
	AND u1_AND(s_1_1,y[4],s_1_2);
	wire temp_s_1,temp_s_2;
	NOT u1_NOT(y[4],temp_s_1);
	AND u2_AND(temp_s_1,r_1_1,temp_s_2);
	XOR u22_XOR(s_1_2,temp_s_2,s_1);

	wire s_2_1,s_2_2;
	XOR u23_XOR(x[1],r_1_2,s_2_1);
	AND u3_AND(s_2_1,y[4],s_2_2);
	wire temp_s_3,temp_s_4;
	NOT u2_NOT(y[4],temp_s_3);
	AND u4_AND(temp_s_3,r_1_2,temp_s_4);
	XOR u24_XOR(s_2_2,temp_s_4,s_2);

	wire s_3_1,s_3_2;
	XOR u25_XOR(x[2],r_1_3,s_3_1);
	AND u5_AND(s_3_1,y[4],s_3_2);
	wire temp_s_5,temp_s_6;
	NOT u3_NOT(y[4],temp_s_5);
	AND u6_AND(temp_s_5,r_1_3,temp_s_6);
	XOR u26_XOR(s_3_2,temp_s_6,s_3);

	wire s_4_1,s_4_2;
	XOR u27_XOR(x[3],r_1_4,s_4_1);
	AND u7_AND(s_4_1,y[4],s_4_2);
	wire temp_s_7,temp_s_8;
	NOT u4_NOT(y[4],temp_s_7);
	AND u8_AND(temp_s_7,r_1_4,temp_s_8);
	XOR u28_XOR(s_4_2,temp_s_8,s_4);

	// / ti
	wire t_1_1,t_1_2;
	XOR u41_XOR(y[0],s_1,t_1_1);
	AND u21_AND(t_1_1,x[4],t_1_2);
	wire temp_t_1,temp_t_2;
	NOT u11_NOT(x[4],temp_t_1);
	AND u22_AND(temp_t_1,s_1,temp_t_2);
	XOR u42_XOR(t_1_2,temp_t_2,t_1);

	wire t_2_1,t_2_2;
	XOR u43_XOR(y[1],s_2,t_2_1);
	AND u23_AND(t_2_1,x[4],t_2_2);
	wire temp_t_3,temp_t_4;
	NOT u12_NOT(x[4],temp_t_3);
	AND u24_AND(temp_t_3,s_2,temp_t_4);
	XOR u44_XOR(t_2_2,temp_t_4,t_2);

	wire t_3_1,t_3_2;
	XOR u45_XOR(y[2],s_3,t_3_1);
	AND u25_AND(t_3_1,x[4],t_3_2);
	wire temp_t_5,temp_t_6;
	NOT u13_NOT(x[4],temp_t_5);
	AND u26_AND(temp_t_5,s_3,temp_t_6);
	XOR u46_XOR(t_3_2,temp_t_6,t_3);

	wire t_4_1,t_4_2;
	XOR u47_XOR(y[3],s_4,t_4_1);
	AND u27_AND(t_4_1,x[4],t_4_2);
	wire temp_t_7,temp_t_8;
	NOT u14_NOT(x[4],temp_t_7);
	AND u28_AND(temp_t_7,s_4,temp_t_8);
	XOR u48_XOR(t_4_2,temp_t_8,t_4);

	// / zi
	wire z_1,z_2,z_3,z_4;
	AND u41_AND(x[4],y[4],z_1);
	XOR u61_XOR(z_1,t_1,z_2);
	XOR u62_XOR(z_2,t_2,z_3);
	XOR u63_XOR(z_3,t_3,z_4);
	XOR u70_XOR(z_4,t_4,z[4]);
	BUF u1_BUF(r[0],z[0]);
	BUF u2_BUF(r[1],z[1]);
	BUF u3_BUF(r[2],z[2]);
	BUF u4_BUF(r[3],z[3]);

endmodule