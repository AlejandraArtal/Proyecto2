`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:39:15 04/18/2016 
// Design Name: 
// Module Name:    ContadorLEctura 
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
module ContadorLectura(input AD_IN, WR_IN, RD_IN,  flagLectura, input [7:0] Dir, Dato,
							 output AD_OUT, WR_OUT, RD_OUT, CS_OUT,output [7:0] DirOut, DatoOut
    );
reg AD, WR, RD, CS;
reg [7:0] DirReg, DatoReg;
reg [5:0] contadorCS, contadorRD, contadorWR, contadorAD, contadorDatoDir;
localparam [3:0] s0 = 4'b0000, s1= 4'b0001,s2= 4'b00010, s3= 4'b00011;
reg state_reg, state_next;

always @(posedge clk, posedge reset) 
		if (reset) begin
			contadorAD <= 6'b0;
			contadorCS <= 6'b0;
			contadorRD <= 6'b0;
			contadorWR <= 6'b0;
			contadorDatoDir <= s0;
			AD <= 1'b0;
			WR <= 1'b0;
			RD <= 1'b0;
			CS <= 1'b0;
			DirReg <= 8'b0;
			DatoReg <= 8'b0;
			state_reg <= s0;
			end
		else begin
			state_reg <= state_next;
			AD_OUT <= AD;
			WR_OUT <= WR;
			RD_OUT <= RD;
			CS_OUT <= CS;
			DirOut <= DirReg;
			DatoOut <= DatoReg;
		end
//always @* begin// contador AD

//always @* begin*// contador WR, RD, CS
//if (contador) begin

//end


//end
//always @* begin*// contador RD
//if ()


//end
//always @* begin// contador CS
//if (flagLectura) begin
	
//end
//end
//always @* begin*// contador Dato y Direccion
//if ()
//end


//endmodule
