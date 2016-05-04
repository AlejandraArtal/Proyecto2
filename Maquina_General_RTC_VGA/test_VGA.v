`timescale 1ns / 1ps
module test_VGA;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] cambio_dia;
	reg [7:0] cambio_mes;
	reg [7:0] cambio_year;
	reg [7:0] hora_t;
	reg [7:0] hora_c;
	reg [7:0] min_t;
	reg [7:0] min_c;
	reg [7:0] seg_t;
	reg [7:0] seg_c;
	reg alarma_signal;

	// Outputs
	wire hsync;
	wire vsync;
	wire [9:0] pixel_x;
	wire [9:0] pixel_y;
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;

	// Instantiate the Unit Under Test (UUT)
	mainModule uut (
		.clk(clk), 
		.reset(reset), 
		.cambio_dia(cambio_dia), 
		.cambio_mes(cambio_mes), 
		.cambio_year(cambio_year), 
		.hora_t(hora_t), 
		.hora_c(hora_c), 
		.min_t(min_t), 
		.min_c(min_c), 
		.seg_t(seg_t), 
		.seg_c(seg_c), 
		.alarma_signal(alarma_signal), 
		.hsync(hsync), 
		.vsync(vsync), 
		.pixel_x(pixel_x), 
		.pixel_y(pixel_y), 
		.red(red), 
		.green(green), 
		.blue(blue)
	);
	
	initial forever
	#5 clk=~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		cambio_dia = 0;
		cambio_mes = 0;
		cambio_year = 0;
		hora_t = 0;
		hora_c = 0;
		min_t = 0;
		min_c = 0;
		seg_t = 0;
		seg_c = 0;
		alarma_signal = 0;

		// Wait 100 ns for global reset to finish
		#100;
      clk = 1;
		reset = 0;
		cambio_dia = 15;
		cambio_mes = 10;
		cambio_year = 3;
		hora_t = 5;
		hora_c = 13;
		min_t = 8;
		min_c = 7;
		seg_t = 6;
		seg_c = 5;
		alarma_signal = 0;
		
		#1000000000;
		$stop;
		// Add stimulus here

	end
      
endmodule

