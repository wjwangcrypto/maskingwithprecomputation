`timescale 1ns/100ps

module Mul2_tb();
    reg clk;
	reg[2:0] x;
	reg[2:0] y;
	reg[1:0] r;
	wire[2:0] z;

    initial 
        begin
            clk=1'b0;
        end

    initial
        begin
            #100 $stop;
        end

    always #10 clk=~clk;

	// At posedge of clk, run Mul1.
	always @(posedge clk)
		begin 
			r[0] <= {$random}%2;
			r[1] <= {$random}%2;

			x[0] = {$random}%2;
			x[1] = {$random}%2;

			y[0] = {$random}%2;
			y[1] = {$random}%2;

			x[2] = x^x[0]^x[1];
			y[2] = y^y[0]^y[1];
		end

    //iverilog
	initial
		begin            
			$dumpfile("Mul2_tb.vcd");//Generate vcd.
			$dumpvars(0, Mul2_tb);//The name of testbench.
		end

	//Instance Mul1.
	Mul2 u_Mul2 (
		.clk(clk),
		.x(x),
		.y(y),
		.r(r),
		.z(z)
	);
endmodule