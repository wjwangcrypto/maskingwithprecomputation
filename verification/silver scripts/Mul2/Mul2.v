`include "custom_cells.v"			// Should be commented out in yosys.

module Mul2(
	input clk,
	input[2:0] x,
	input[2:0] y,
	input[1:0] r,
	output[2:0] z);

	wire u_1,s_1,t_1, u_2,s_2,t_2;

	// Mul2
	XOR u1_XOR(x[0],y[0],u_1);
	XOR u2_XOR(x[1],y[1],u_2);

	// / ri
	wire r_1_1,r_2_1;
	XOR u3_XOR(r[0],u_1,r_1_1);
	XOR u4_XOR(r[1],u_2,r_2_1);

	// / si
	wire s_1_1,s_1_2;
	XOR u5_XOR(x[0],r_1_1,s_1_1);
	AND u1_AND(s_1_1,y[2],s_1_2);
	wire temp_s_1,temp_s_2;
	NOT u1_NOT(y[2],temp_s_1);
	AND u2_AND(temp_s_1,r_1_1,temp_s_2);
	XOR u6_XOR(s_1_2,temp_s_2,s_1);

	wire s_2_1,s_2_2;
	XOR u7_XOR(x[1],r_2_1,s_2_1);
	AND u3_AND(s_2_1,y[2],s_2_2);
	wire temp_s_3,temp_s_4;
	NOT u2_NOT(y[2],temp_s_3);
	AND u4_AND(temp_s_3,r_2_1,temp_s_4);
	XOR u8_XOR(s_2_2,temp_s_4,s_2);
	// / ti
	wire t_1_1,t_1_2;
	XOR u9_XOR(y[0],s_1,t_1_1);
	AND u5_AND(t_1_1,x[2],t_1_2);
	wire temp_t_1,temp_t_2;
	NOT u3_NOT(x[2],temp_t_1);
	AND u6_AND(temp_t_1,s_1,temp_t_2);
	XOR u10_XOR(t_1_2,temp_t_2,t_1);

	wire t_2_1,t_2_2;
	XOR u11_XOR(y[1],s_2,t_2_1);
	AND u7_AND(t_2_1,x[2],t_2_2);
	wire temp_t_3,temp_t_4;
	NOT u4_NOT(x[2],temp_t_3);
	AND u8_AND(temp_t_3,s_2,temp_t_4);
	XOR u12_XOR(t_2_2,temp_t_4,t_2);
	// / zi
	wire z_2_1,z_2_2;
	AND u9_AND(x[2],y[2],z_2_1);
	XOR u13_XOR(z_2_1,t_1,z_2_2);
	XOR u14_XOR(z_2_2,t_2,z[2]);
	BUF u1_BUF(r[0],z[0]);
	BUF u2_BUF(r[1],z[1]);

endmodule