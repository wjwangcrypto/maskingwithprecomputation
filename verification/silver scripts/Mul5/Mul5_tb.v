`timescale 1ns/100ps

module Mul5_tb();
    reg clk;
	reg[5:0] x;
	reg[5:0] y;
	reg[4:0] r;
	wire[5:0] z;

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
			r[4] <= {$random}%2;

			x[0] = {$random}%2;
			x[1] = {$random}%2;
			x[2] = {$random}%2;
			x[3] = {$random}%2;
			x[4] = {$random}%2;

			y[0] = {$random}%2;
			y[1] = {$random}%2;
			y[2] = {$random}%2;
			y[3] = {$random}%2;
			y[4] = {$random}%2;

			x[5] = x^x[0]^x[1]^x[2]^x[3]^x[4];
			y[5] = y^y[0]^y[1]^y[2]^y[3]^y[4];
		end

    //iverilog
	initial
		begin            
			$dumpfile("Mul5_tb.vcd");//Generate vcd.
			$dumpvars(0, Mul5_tb);//The name of testbench.
		end

	//Instance Mul1.
	Mul5 u_Mul5 (
		.clk(clk),
		.x(x),
		.y(y),
		.r(r),
		.z(z)
	);
endmodule