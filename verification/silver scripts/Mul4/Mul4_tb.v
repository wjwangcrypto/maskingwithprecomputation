`timescale 1ns/100ps

module Mul4_tb();
    reg clk;
	reg[4:0] x;
	reg[4:0] y;
	reg[3:0] r;
	wire[4:0] z;

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
			r[3] <= {$random}%2;

			x[0] = {$random}%2;
			x[1] = {$random}%2;
			x[2] = {$random}%2;
			x[3] = {$random}%2;

			y[0] = {$random}%2;
			y[1] = {$random}%2;
			y[2] = {$random}%2;
			y[3] = {$random}%2;

			x[4] = x^x[0]^x[1]^x[2]^x[3];
			y[4] = y^y[0]^y[1]^y[2]^y[3];
		end

    //iverilog
	initial
		begin            
			$dumpfile("Mul4_tb.vcd");//Generate vcd.
			$dumpvars(0, Mul4_tb);//The name of testbench.
		end

	//Instance Mul1.
	Mul4 u_Mul4 (
		.clk(clk),
		.x(x),
		.y(y),
		.r(r),
		.z(z)
	);
endmodule