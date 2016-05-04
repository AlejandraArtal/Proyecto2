`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:36:33 04/03/2016 
// Design Name: 
// Module Name:    HorasT 
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
 module HorasT(input clk,enable, reset,input UP,input DOWN, input [7:0] horas, output reg A_DH0, W_RH0, output reg [7:0] DireccionH0, output reg flagHD00, flagHA00,flagH00
    );
reg AD, WR, flagD, flagA, flag;
reg [7:0] datohor =0;
reg [7:0] Direccion;
// symbolic state declaration 
	localparam [1:0] s0 = 2'b00,s1 = 2'b01,s2 = 2'b10; 	
// signal declaration 
	reg [1:0] state_reg , state_next ;

// state register
	always @(posedge clk, posedge reset) 
		if ((reset)||(enable==1'b0)) begin
			state_reg <= s0;
			A_DH0 <= 8'b0;
			DireccionH0 <= 8'b0;
			W_RH0 <= 1'b0;
			flagHD00 <= 1'b0;
			flagHA00 <= 1'b0;
			flagH00  <= 1'b0;
			end
		else begin
			state_reg <= state_next; 
			A_DH0 <= AD;
			DireccionH0 <= Direccion;
			W_RH0 <= WR;
			flagHD00 <= flagD;
			flagHA00 <= flagA;
			flagH00  <= flag;
		end
// next-state logic and output logic 
	always @ * begin
		state_next = state_reg; 
			case (state_reg) 
				s0: begin
					if ((UP==1'b1)&&(DOWN==1'b0)) begin
						if (horas == 8'h23) begin
							datohor = 8'h0;
							state_next = s1;
							AD = 1'b0;
							WR = 1'b0;
							flagD = 1'b0;
							flagA = 1'b0;
							flag = 1'b0;
						end
						else  begin
							AD = 1'b0;
							WR = 1'b0;
							datohor = horas +1'h1;
							state_next = s1;
							flagD = 1'b0;
							flagA = 1'b0;
							flag = 1'b0;
						end
					end
					else if ((UP==1'b0)&&(DOWN==1'b1)) begin 
						if (horas == 8'h0) begin
							datohor = 8'h23;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flagD = 1'b0;
							flagA = 1'b0;
							flag = 1'b0;
						end
						else begin
							datohor = horas - 1'h1;
							AD = 1'b0;
							WR = 1'b0;
							state_next = s1;
							flagD = 1'b0;
							flagA = 1'b0;
							flag = 1'b0;
						end
					end
					else begin
						datohor = horas;
						AD = 1'b0;
						WR = 1'b0;
						state_next = s1;
						flagD = 1'b0;
						flagA = 1'b0;
						flag = 1'b0;
					end 
				end
				s1: begin
					AD = 1'b0;
					WR = 1'b0;
					//flag = 1'b1;
					Direccion = 8'h23;
					state_next =s2;
					flagD = 1'b1;
					flagA = 1'b0;
					flag = 1'b1;
				end
				s2:begin
					AD = 1'b1;
					WR = 1'b1;
					Direccion = datohor;
					flagA = 1'b1;
					flagD = 1'b0;
					flag = 1'b1;
					state_next = s0;
				end	
				default begin
					state_next= s0;
				end
			endcase
		end
endmodule
