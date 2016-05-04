`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:17 04/03/2016 
// Design Name: 
// Module Name:    YearF 
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
module Year(input clk,enable, reset,input UP,input DOWN, input [7:0] year, output reg A_DY, W_RY, output reg [7:0] DireccionY0, output reg flagY00,
				flagYA00,flagYD00);
reg AD, WR, flag,flagA,flagD;
reg [7:0] datoyear = 8'b0;
reg [7:0] Direccion = 8'b0;
// symbolic state declaration 
	localparam [1:0] s0 = 2'b00,s1 = 2'b01,s2 = 2'b10; 	
// signal declaration 
	reg [1:0] state_reg , state_next ;

// state register
	always @(posedge clk, posedge reset) 
		if ((reset)||(enable==1'b0)) begin
			state_reg <= s0;
			A_DY <= 8'b0;
			DireccionY0 <= 8'b0;
			W_RY <= 1'b0;
			flagY00 <= 1'b0;
			flagYA00 <= 1'b0;
			flagYD00 <= 1'b0;
			end
		else begin
			state_reg <= state_next; 
			A_DY <= AD;
			DireccionY0 <= Direccion;
			W_RY <= WR;
			flagY00 <= flag;
			flagYA00 <= flagA;
			flagYD00 <= flagD;
			end
// next-state logic and output logic 
	always @ * begin
		state_next = state_reg; 
			case (state_reg) 
				s0: begin
					if ((UP==1'b1)&&(DOWN==1'b0)) begin
						if (year == 8'h99) begin
							datoyear = 8'h0;
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
							datoyear = year +1'h1;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
					end
					else if ((UP==1'b0)&&(DOWN==1'b1)) begin 
						if (year == 8'h0) begin
							datoyear = 8'h99;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
						else begin
							datoyear = year - 1'h1;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
						end
					end
					else begin
						datoyear = year;
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
					Direccion = 8'h26;
					state_next =s2;
					flag = 1'b1;
					flagD = 1'b0;
					flagA = 1'b1;
				end
				s2:begin
					AD = 1'b1;
					WR = 1'b1;
					Direccion = datoyear;
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
