`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:36 04/03/2016 
// Design Name: 
// Module Name:    segundosT 
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
module SegundosC(input clk,enable, reset,input UP,input DOWN, input [7:0] segundos, output reg A_DS, W_RS, output reg [7:0] DireccionS0, output reg flagS00, 
						flagSA00,flagSD00);
reg AD, WR, flag, flagD, flagA;
reg [7:0] datoseg;
reg [7:0] Direccion;
// symbolic state declaration 
	localparam [1:0] s0 = 2'b00,s1 = 2'b01,s2 = 2'b10; 	
// signal declaration 
	reg [1:0] state_reg , state_next ;

// state register
	always @(posedge clk, posedge reset) 
		if ((reset)||(enable==1'b0)) begin
			state_reg <= s0;
			A_DS <= 8'b0;
			DireccionS0 <= 8'b0;
			W_RS <= 1'b0;
			flagS00 <= 1'b0;
			flagSD00 <= 1'b0;
			flagSA00 <= 1'b0;
			end
		else begin
			state_reg <= state_next; 
			A_DS <= AD;
			DireccionS0 <= Direccion;
			W_RS <= WR;
			flagS00 <= flag;
			flagSD00 <= flagD;
			flagSA00 <= flagA;
		end
// next-state logic and output logic 
	always @ * begin
		state_next = state_reg; 
			case (state_reg) 
				s0: begin
					if ((UP==1'b1)&&(DOWN==1'b0)) begin
						if (segundos == 8'h23) begin
							datoseg = 8'h0;
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
							datoseg = segundos +1'h1;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
					end
					else if ((UP==1'b0)&&(DOWN==1'b1)) begin 
						if (segundos == 8'h0) begin
							datoseg = 8'h23;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
						else begin
							datoseg = segundos - 1'h1;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
					end
					else begin
						datoseg = segundos;
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
					flag = 1'b1;
					flagA = 1'b0;
					flagD = 1'b1;
					Direccion = 8'h41;
					state_next =s2;
				end
				s2:begin
					AD = 1'b1;
					WR = 1'b1;
					Direccion = datoseg;
					flag = 1'b1;
					flagA = 1'b1;
					flagD = 1'b0;
					state_next = s0;
				end	
				default begin
					state_next= s0;
				end
			endcase
		end
endmodule
