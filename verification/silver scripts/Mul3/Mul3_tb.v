`timescale 1ns/100ps

module Mul3_tb();
    reg clk;
	reg[3:0] x;
	reg[3:0] y;
	reg[2:0] r;
	wire[3:0] z;

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
			r[2] <= {$random}%2;

			x[0] = {$random}%2;
			x[1] = {$random}%2;
			x[2] = {$random}%2;

			y[0] = {$random}%2;
			y[1] = {$random}%2;
			y[2] = {$random}%2;

			x[3] = x^x[0]^x[1]^x[2];
			y[3] = y^y[0]^y[1]^y[2];
		end

    //iverilog
	initial
		begin            
			$dumpfile("Mul3_tb.vcd");//Generate vcd.
			$dumpvars(0, Mul3_tb);//The name of testbench.
		end

	//Instance Mul1.
	Mul3 u_Mul3 (
		.clk(clk),
		.x(x),
		.y(y),
		.r(r),
		.z(z)
	);
endmodule