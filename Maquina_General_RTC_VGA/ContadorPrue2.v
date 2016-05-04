`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:07 04/11/2016 
// Design Name: 
// Module Name:    ContadorPrue2 
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
module ContadorCircuito(input reset,enable ,clk, input [7:0] x,input [7:0] DatoIn ,output reg [7:0] DatoOut );
	reg [7:0] datcount;
	always @(posedge clk,  posedge reset) begin // cualquiera de las dos opciones. ingresa al ciclo
	datcount <= 8'b0;
		if (reset) begin
			datcount <= 8'b0;
		end
		else if(enable) begin
			if (datcount < x) begin// conteo hasta 31
				datcount <= datcount + 1;
			end
			else begin
				DatoOut <= DatoIn;
				datcount <= 8'b0;
			end
		end
	end
endmodule
