`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:33 04/11/2016 
// Design Name: 
// Module Name:    contador 
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
 module count(clk, rst,x, DatoIn,DatoOut);
    input  clk, rst;
	 input [7:0] DatoIn;
	 input [3:0] x;
	 output reg [7:0] DatoOut;
    reg [3:0] val, nval;

    always @(posedge clk or negedge rst)
      if(rst == 1'b1) begin
			val = 0;
			DatoOut=0;
			nval= 4'b0;
		end	
      else if (nval != x) begin
			nval <= val + 1'b1;
		end
		else
			DatoOut = DatoIn; 
    
 endmodule
 