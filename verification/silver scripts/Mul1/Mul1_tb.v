`timescale 1ns/100ps

module Mul1_tb();
    reg clk;
	reg[1:0] x;
	reg[1:0] y;
	reg[0:0] r1;
	wire[1:0] z;

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
			r1 <= {$random}%2;
			omega<=1'b1;
			x[0] = {$random}%2;
			y[0] = {$random}%2;
			x[1] = x^x[0];
			y[1] = y^y[0];
		end

    //iverilog
	initial
		begin            
			$dumpfile("Mul1_tb.vcd");//Generate vcd.
			$dumpvars(0, Mul1_tb);//The name of testbench.
		end

	//Instance Mul1.
	Mul1 u_Mul1 (
		.clk(clk),
		.x(x),
		.y(y),
		.r1(r1),
		.z(z)
	);
endmodule