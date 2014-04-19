`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:04:00 08/25/2013
// Design Name:   vgaPong
// Module Name:   C:/Users/Sam/Documents/FPGA/vgaPong/tb_vgapong.v
// Project Name:  vgaPong
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vgaPong
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_vgapong;

	// Inputs
	reg clk;
	reg joy_right;
	reg joy_left;
	reg joy_up;
	reg joy_down;
	reg joy_select;

	// Instantiate the Unit Under Test (UUT)
	vgaPong uut (
		.clk(clk), 
		.joy_right(joy_right), 
		.joy_left(joy_left), 
		.joy_up(joy_up), 
		.joy_down(joy_down), 
		.joy_select(joy_select)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		joy_right = 0;
		joy_left = 0;
		joy_up = 0;
		joy_down = 0;
		joy_select = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

