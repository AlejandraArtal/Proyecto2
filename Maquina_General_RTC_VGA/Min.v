`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:38:22 04/03/2016 
// Design Name: 
// Module Name:    Min 
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
module MinT(input clk,enable, reset,input UP,input DOWN, input [7:0] minutos, output reg A_DM, W_RM, output reg [7:0] DireccionM0, output reg flagM00,
				flagMA00, flagMD00);
reg AD, WR, flag, flagA,flagD;
reg [7:0] datomin;
reg [7:0] Direccion;
// symbolic state declaration 
	localparam [1:0] s0 = 2'b00,s1 = 2'b01,s2 = 2'b10; 	
// signal declaration 
	reg [1:0] state_reg , state_next ;

// state register
	always @(posedge clk, posedge reset) 
		if ((reset)||(enable==1'b0)) begin
			state_reg <= s0;
			A_DM <= 8'b0;
			DireccionM0 <= 8'b0;
			W_RM <= 1'b0;
			flagM00  <= 1'b0;
			flagMA00 <= 1'b0;
			flagMD00 <= 1'b0;
			end
		else begin
			state_reg <= state_next; 
			A_DM <= AD;
			DireccionM0 <= Direccion;
			W_RM <= WR;
			flagM00 <= flag;
			flagMA00 <= flagA;
			flagMD00 <= flagD;
			end
// next-state logic and output logic 
	always @ * begin
		state_next = state_reg; 
			case (state_reg) 
				s0: begin
					if ((UP==1'b1)&&(DOWN==1'b0)) begin
						if (minutos == 8'h59) begin
							datomin = 8'h0;
							state_next = s1;
							AD = 1'b0;
							WR = 1'b0;
							flag = 1'b0;
						end
						else  begin
							AD = 1'b0;
							WR = 1'b0;
							datomin = minutos +1'h1;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
					end
					else if ((UP==1'b0)&&(DOWN==1'b1)) begin 
						if (minutos == 8'h0) begin
							datomin = 8'h59;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
						else begin
							datomin = minutos - 1'h1;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flag = 1'b0;
							flagA = 1'b0;
							flagD = 1'b0;
						end
					end
					else begin
						datomin = minutos;
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
					Direccion = 8'h22;
					state_next =s2;
					flag = 1'b1;
					flagA = 1'b0;
					flagD = 1'b1;
				end
				s2:begin
					AD = 1'b1;
					WR = 1'b1;
					Direccion = datomin;
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
