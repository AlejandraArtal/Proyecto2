`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:47 04/03/2016 
// Design Name: 
// Module Name:    DiaF 
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
module DiaF(input clk,enable, reset,input UP,input DOWN, input [7:0] dia, output reg A_DD, W_RD, output reg [7:0] DireccionD0, output reg flagD00,
	flagDA00,flagDD00);
reg AD, WR, flag, flagA, flagD;
reg [7:0] datodia = 8'b0;
reg [7:0] Direccion = 8'b0;
// symbolic state declaration 
	localparam [1:0] s0 = 2'b00,s1 = 2'b01,s2 = 2'b10; 	
// signal declaration 
	reg [1:0] state_reg , state_next ;

// state register
	always @(posedge clk, posedge reset) 
		if ((reset)||(enable==1'b0)) begin
			state_reg <= s0;
			A_DD <= 8'b0;
			DireccionD0 <= 8'b0;
			W_RD <= 1'b0;
			flagD00 <= 1'b0;
			flagDD00 <= 1'b0;
			flagDA00 <= 1'b0;
			end
		else begin
			state_reg <= state_next; 
			A_DD <= AD;
			DireccionD0 <= Direccion;
			W_RD <= WR;
			flagD00   <= flag;
			flagDD00 <= flagD;
			flagDA00 <= flagA;
		end
// next-state logic and output logic 
	always @ * begin
		state_next = state_reg; 
			case (state_reg) 
				s0: begin
					if ((UP==1'b1)&&(DOWN==1'b0)) begin
						if (dia == 8'h31) begin
							datodia = 8'h0;
							state_next = s1;
							AD = 1'b0;
							WR = 1'b0;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;

						end
						else  begin
							AD = 1'b0;
							WR = 1'b0;
							datodia = dia +1'h1;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;

						end
					end
					else if ((UP==1'b0)&&(DOWN==1'b1)) begin 
						if (dia ==8'h0) begin
							datodia = 8'h31;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;


						end
						else begin
							datodia= dia - 1'h1;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
					end
					else begin
						datodia = dia;
						AD = 1'b0;
						WR = 1'b0;
						state_next = s1;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end 
				end
				s1: begin
					AD = 1'b0;
					WR = 1'b0;
					Direccion = 8'h24;
					state_next =s2;
					flag = 1'b1;
					flagD = 1'b0;
					flagA = 1'b1;
				end
				s2:begin
					AD = 1'b1;
					WR = 1'b1;
					Direccion = datodia;
					state_next = s0;
					flag = 1'b1;
					flagD = 1'b1;
					flagA = 1'b0;
				end	
				default begin
					state_next= s0;
				end
			endcase
		end
endmodule
