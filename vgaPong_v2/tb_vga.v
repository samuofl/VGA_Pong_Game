`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:11:04 08/27/2013
// Design Name:   vgaPong
// Module Name:   C:/Users/Sam/Documents/FPGA/vgaPong/tb_vga.v
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

module tb_vga;

	// Inputs
	reg clk;
	reg joy_right;
	reg joy_left;
	reg joy_up;
	reg joy_down;
	reg joy_select;

	// Outputs
	wire vsync;
	wire hsync;
	wire [1:0] blue;
	wire [2:0] green;
	wire [2:0] red;

	// Instantiate the Unit Under Test (UUT)
	vgaPong uut (
		.vsync(vsync), 
		.hsync(hsync), 
		.blue(blue), 
		.green(green), 
		.red(red), 
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

      
endmodule

