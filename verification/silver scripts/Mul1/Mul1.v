`include "custom_cells.v"			// Should be commented out in yosys.

module Mul1(
	input clk,
	input[1:0] x,
	input[1:0] y,
	input[0:0] r1,
	output[1:0] z);

	wire u_1,s_1,t_1;

	// Mul1
	XOR u3_XOR(x[0],y[0],u_1);
	wire r_1_1;
	XOR u4_XOR(r1,u_1,r_1_1);
	// / si
	wire s_1_1,s_1_2;
	XOR u5_XOR(x[0],r_1_1,s_1_1);
	AND u1_AND(s_1_1,y[1],s_1_2);
	wire temp_1,temp_2;
	NOT u1_NOT(y[1],temp_1);
	AND u2_AND(temp_1,r_1_1,temp_2);
	XOR u7_XOR(s_1_2,temp_2,s_1);
	// / ti
	wire t_1_1,t_1_2;
	XOR u8_XOR(y[0],s_1,t_1_1);
	AND u3_AND(t_1_1,x[1],t_1_2);
	wire temp_3,temp_4;
	NOT u2_NOT(x[1],temp_3);
	AND u4_AND(temp_3,s_1,temp_4);
	XOR u10_XOR(t_1_2,temp_4,t_1);
	// / zi
	wire z_2_1;
	AND u5_AND(x[1],y[1],z_2_1);
	XOR u11_XOR(z_2_1,t_1,z[1]);
	BUF u2_BUF(r1,z[0]);

endmodule