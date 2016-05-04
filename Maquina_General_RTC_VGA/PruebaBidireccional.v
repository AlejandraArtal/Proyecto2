`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:55:05 04/19/2016 
// Design Name: 
// Module Name:    PruebaBidireccional 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PruebaBidireccional(inout top_level_port, input clock, reset);

wire output_enable_signal, output_signal;
reg  input_reg;   
assign top_level_port = (output_enable_signal) ? output_signal : 1'bz;  
always @(posedge clock)
   if (reset)
      input_reg  <= 1'b0;
	else
      input_reg  <= top_level_port;			
endmodule
