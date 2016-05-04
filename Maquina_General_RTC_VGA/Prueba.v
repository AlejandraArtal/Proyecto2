`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:46:37 04/03/2016
// Design Name:   MaquinaTiempo
// Module Name:   C:/Users/Alejandra/Desktop/Proyecto2/Prueba3/Prueba.v
// Project Name:  Prueba3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MaquinaTiempo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Prueba;

	// Inputs
	reg enableT;
	reg clk;
	reg reset;
	reg UP;
	reg DOWN;
	reg LEFT;
	reg RIGHT;
	reg [7:0] horaT;
	reg [7:0] minT;
	reg [7:0] segT;

	// Outputs
	wire [7:0] Direccion0;
	wire flagprincipal;
	wire A_DT;
	wire W_RT;

	// Instantiate the Unit Under Test (UUT)
	MaquinaTiempo uut (
		.enableT(enableT), 
		.clk(clk), 
		.reset(reset), 
		.UP(UP), 
		.DOWN(DOWN), 
		.LEFT(LEFT), 
		.RIGHT(RIGHT), 
		.horaT(horaT), 
		.minT(minT), 
		.segT(segT), 
		.Direccion0(Direccion0), 
		.flagprincipal(flagprincipal), 
		.A_DT(A_DT), 
		.W_RT(W_RT)
	);

	initial begin
		// Initialize Inputs
		enableT = 0;
		clk = 0;
		reset = 0;
		UP = 0;
		DOWN = 0;
		LEFT = 0;
		RIGHT = 0;
		horaT = 0;
		minT = 0;
		segT = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

