`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:47 04/03/2016 
// Design Name: 
// Module Name:    MaquinaFecha 
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
module MaquinaFecha(input enableF, clk, reset, UP, DOWN, LEFT, RIGHT, input [7:0] DireccionIN,
							output reg [7:0] DireccionF0,/*output reg flagprincipalF,*/ output reg A_DF, W_RF, flagAF,flagDF
    );
reg enableD, enableM, enableY;
reg AD, WR, flag,flagA,flagD;
reg [7:0] Direccion;
wire [7:0] DireccionD0, DireccionM0, DireccionY0;
wire A_DD, W_RD, A_DM, A_DY, W_RM, W_RY;
// Instantiate the module
DiaF instance_Dia (
    .clk(clk), 
    .enable(enableD), 
    .reset(reset), 
    .UP(UP), 
    .DOWN(DOWN), 
    .dia(DireccionIN), 
    .A_DD(A_DD), 
    .W_RD(W_RD), 
    .DireccionD0(DireccionD0), 
    .flagD00(flagD0),
	 .flagDA00(flagDA0),
	 .flagDD00(flagDD0)
    );

// Instantiate the module
Mes instance_Mes (
    .clk(clk), 
    .enable(enableM), 
    .reset(reset), 
    .UP(UP), 
    .DOWN(DOWN), 
    .mes(DireccionIN), 
    .A_DM(A_DM), 
    .W_RM(W_RM), 
    .DireccionM0(DireccionM0), 
    .flagM00(flagM0),
	 .flagMA00(flagMA0),
	 .flagMD00(flagMD0)
    );

// Instantiate the module
Year instance_Year (
    .clk(clk), 
    .enable(enableY), 
    .reset(reset), 
    .UP(UP), 
    .DOWN(DOWN), 
    .year(DireccionIN), 
    .A_DY(A_DY), 
    .W_RY(W_RY), 
    .DireccionY0(DireccionY0), 
    .flagY00(flagY0),
	 .flagYA00(flagYA0),
	 .flagYD00(flagYD0)
    );

// estados de la máquina
localparam [2:0] s0 = 3'b00,//hora
					  s1 = 3'b01,//min
					  s2 = 3'b10,//seg
					  s3 = 3'b11,//actualizarDato
					  s4 = 3'b100;
//cambio de estados
reg [2:0] state_reg, state_next;
// registro estático
	always @(posedge clk, posedge reset) 
		if ((reset)||(enableF==1'b0)) begin
			state_reg <= s0;
			A_DF <= 1'b0;
			W_RF <= 1'b0;
//			flagprincipalF <= 1'b0;
			flagDF <= 1'b0;
			flagAF <= 1'b0;
			end
		else begin
			state_reg <= state_next;
			DireccionF0 <= Direccion;
			A_DF <= AD;
			W_RF <= WR;
//			flagprincipalF <= flag;
			flagDF <= flagD;
			flagAF <= flagA; 
		end
// next-state logic and output logic 
	always @* 
	begin
		state_next = state_reg; 
		//datomin = minutos;
		AD = A_DF;
		Direccion = DireccionF0;
		WR = W_RF;
//		flag = flagprincipalF;
			case (state_reg) 
				s0: begin
					if (LEFT) begin
						enableY = 1'b1;
						enableM = 1'b0;
						enableD = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
					else if (RIGHT) begin
						enableM = 1'b1;
						enableD = 1'b0;
						enableY = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
					else begin
						enableD = 1'b1;
						enableY = 1'b0;
						enableM = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
				end	
				s1: begin
					if (LEFT) begin
						enableD = 1'b1;
						enableY = 1'b0;
						enableM = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
					else if (RIGHT) begin
						enableY = 1'b1;
						enableM = 1'b0;
						enableD = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
					else begin
						enableM = 1'b1;
						enableD = 1'b0;
						enableY = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
				end	
				s2:
				begin
					if (LEFT) begin
						enableM = 1'b1;
						enableD = 1'b0;
						enableY = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
					else if (RIGHT) begin
						enableD = 1'b1;
						enableY = 1'b0;
						enableM = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
					else begin
						enableY = 1'b1;
						enableM = 1'b0;
						enableD = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagA = 1'b0;
						flagD = 1'b0;
					end
				end
				s3: begin	
					if (flagD0&&enableD) begin
						if (flagDA0 == 1'b1) begin
							state_next= s4;
							Direccion = DireccionD0;
							WR = W_RD;
							AD = A_DD;
							flag = 1'b1;
							flagD = 1'b1;
							flagA = 1'b0;
						end
						else if (flagDA0 == 1'b0) begin
							state_next = s3;
						end
					end
					else begin
						if (flagM0&&enableM) begin
							if (flagMA0 == 1'b1) begin
								state_next= s4;
								Direccion = DireccionM0;
								WR = W_RM;
								AD = A_DM;
								flag = 1'b1;
								flagD = 1'b1;
								flagA = 1'b0;
							end
							else if (flagMA0 == 1'b0) begin
								state_next = s3;
							end
						end
						else begin
							if (flagY0&&enableY) begin
								if (flagYA0 == 1'b1) begin
									state_next= s4;
									Direccion = DireccionY0;
									WR = W_RY;
									AD = A_DY;
									flag = 1'b1;
									flagD = 1'b1;
									flagA = 1'b0;
								end
								else if (flagYA0 == 1'b0) begin
									state_next = s3;
								end
							end
						end
					end
				end
				s4: begin
					if (flagD0&&enableD) begin
						if (flagDD0== 1'b1) begin
							state_next= s0;
							Direccion = DireccionD0;
							AD =W_RD;
							WR = A_DD;
							flag = 1'b1;
							flagD = 1'b0;
							flagA = 1'b1;
						end
						else if (flagDD0 == 1'b0) begin
							state_next = s4;
						end
					end
					else begin
						if (flagM0&&enableM) begin
							if (flagMD0== 1'b1) begin
								state_next= s1;
								Direccion = DireccionM0;
								AD =W_RM;
								WR = A_DM;
								flag = 1'b1;
								flagD = 1'b0;
								flagA = 1'b1;
							end
							else if (flagMD0 == 1'b0) begin
								state_next = s4;
							end
						end
						else begin
							if (flagY0&&enableY) begin
								if (flagYD0== 1'b1) begin
								state_next= s2;
								Direccion = DireccionY0;
								AD =W_RY;
								WR = A_DY;
								flag = 1'b1;
								flagD = 1'b0;
								flagA = 1'b1;
							end
							else if (flagYD0 == 1'b0) begin
								state_next = s4;
							end
						end
					end
				end
				end
				default begin
					state_next= s0;
					flag = 1'b0;
					flagD = 1'b0;
					flagA = 1'b0;

				end
				endcase
		end
endmodule



