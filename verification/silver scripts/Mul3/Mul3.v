`include "custom_cells.v"			// Should be commented out in yosys.

module Mul3(
	input clk,
	input[3:0] x,
	input[3:0] y,
	input[2:0] r,
	output[3:0] z);

	wire u_1,s_1,t_1, u_2,s_2,t_2, u_3,s_3,t_3;

	// Mul2
	XOR u1_XOR(x[0],y[0],u_1);
	XOR u2_XOR(x[1],y[1],u_2);
	XOR u21_XOR(x[2],y[2],u_3);

	// / ri
	wire r_1_1,r_1_2,r_1_3;
	XOR u3_XOR(r[0],u_1,r_1_1);
	XOR u4_XOR(r[1],u_2,r_1_2);
	XOR u5_XOR(r[2],u_3,r_1_3);

	// / si
	wire s_1_1,s_1_2;
	XOR u6_XOR(x[0],r_1_1,s_1_1);
	AND u1_AND(s_1_1,y[3],s_1_2);
	wire temp_s_1,temp_s_2;
	NOT u1_NOT(y[3],temp_s_1);
	AND u2_AND(temp_s_1,r_1_1,temp_s_2);
	XOR u7_XOR(s_1_2,temp_s_2,s_1);

	wire s_2_1,s_2_2;
	XOR u8_XOR(x[1],r_1_2,s_2_1);
	AND u3_AND(s_2_1,y[3],s_2_2);
	wire temp_s_3,temp_s_4;
	NOT u2_NOT(y[3],temp_s_3);
	AND u4_AND(temp_s_3,r_1_2,temp_s_4);
	XOR u9_XOR(s_2_2,temp_s_4,s_2);

	wire s_3_1,s_3_2;
	XOR u10_XOR(x[2],r_1_3,s_3_1);
	AND u5_AND(s_3_1,y[3],s_3_2);
	wire temp_s_5,temp_s_6;
	NOT u3_NOT(y[3],temp_s_5);
	AND u6_AND(temp_s_5,r_1_3,temp_s_6);
	XOR u11_XOR(s_3_2,temp_s_6,s_3);
	// / ti
	wire t_1_1,t_1_2;
	XOR u12_XOR(y[0],s_1,t_1_1);
	AND u7_AND(t_1_1,x[3],t_1_2);
	wire temp_t_1,temp_t_2;
	NOT u4_NOT(x[3],temp_t_1);
	AND u8_AND(temp_t_1,s_1,temp_t_2);
	XOR u13_XOR(t_1_2,temp_t_2,t_1);

	wire t_2_1,t_2_2;
	XOR u14_XOR(y[1],s_2,t_2_1);
	AND u9_AND(t_2_1,x[3],t_2_2);
	wire temp_t_3,temp_t_4;
	NOT u5_NOT(x[3],temp_t_3);
	AND u10_AND(temp_t_3,s_2,temp_t_4);
	XOR u15_XOR(t_2_2,temp_t_4,t_2);

	wire t_3_1,t_3_2;
	XOR u16_XOR(y[2],s_3,t_3_1);
	AND u11_AND(t_3_1,x[3],t_3_2);
	wire temp_t_5,temp_t_6;
	NOT u6_NOT(x[3],temp_t_5);
	AND u12_AND(temp_t_5,s_3,temp_t_6);
	XOR u17_XOR(t_3_2,temp_t_6,t_3);
	// / zi
	wire z_1,z_2,z_3;
	AND u13_AND(x[3],y[3],z_1);
	XOR u18_XOR(z_1,t_1,z_2);
	XOR u19_XOR(z_2,t_2,z_3);
	XOR u20_XOR(z_3,t_3,z[3]);
	BUF u1_BUF(r[0],z[0]);
	BUF u2_BUF(r[1],z[1]);
	BUF u3_BUF(r[2],z[2]);

endmodule