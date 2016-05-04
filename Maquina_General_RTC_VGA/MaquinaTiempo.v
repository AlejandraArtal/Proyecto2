`timescale 1ns / 1ps

module MaquinaTiempo(input enableT, clk, reset, UP, DOWN, LEFT, RIGHT, input [7:0] DireccionIN,
							output reg [7:0] DireccionT0,/*output reg flagprincipalT,*/ output reg A_DT, W_RT, flagDT, flagAT
							);
reg enableH, enableM, enableS;
reg AD, WR, flag, flagD, flagA;
reg [7:0] Direccion;
wire [7:0] DireccionH0, DireccionM0, DireccionS0;
wire A_DH, W_RH, A_DM, A_DS, W_RM, W_RS;


// Instantiate the module
HorasT instance_Horas (
    .clk(clk), 
    .enable(enableH), 
    .reset(reset), 
    .UP(UP), 
    .DOWN(DOWN), 
    .horas(DireccionIN), 
    .A_DH0(A_DH), 
    .W_RH0(W_RH), 
    .DireccionH0(DireccionH0), 
    .flagHD00(flagHD0),
	 .flagHA00(flagHA0),
	 .flagH00(flagH0)
    );	 

// Instantiate the module
MinT instance_MinT (
    .clk(clk), 
    .enable(enableM), 
    .reset(reset), 
    .UP(UP), 
    .DOWN(DOWN), 
    .minutos(DireccionIN), 
    .A_DM(A_DM), 
    .W_RM(W_RM), 
    .DireccionM0(DireccionM0), 
    .flagM00(flagM0),
	 .flagMA00(flagMA0),
	 .flagMD00(flagMD0)
    );

	 
// Instantiate the module
SegundosT instance_Segundos (
    .clk(clk), 
    .enable(enableS), 
    .reset(reset), 
    .UP(UP), 
    .DOWN(DOWN), 
    .segundos(DireccionIN), 
    .A_DS(A_DS), 
    .W_RS(W_RS), 
    .DireccionS0(DireccionS0), 
    .flagS00(flagS0),
	 .flagSA00(flagSA0),
	 .flagSD00(flagSD0)
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
		if ((reset)||(enableT==1'b0)) begin
			state_reg <= s0;
			A_DT <= 1'b0;
			W_RT <= 1'b0;
//			flagprincipalT <= 1'b0;
			flagDT <= 1'b0;
			flagAT <= 1'b0;
			end
		else begin
			state_reg <= state_next;
			DireccionT0 <= Direccion;
			A_DT <= AD;
			W_RT <= WR;
			//flagprincipalT <= flag;
			flagDT <= flagD;
			flagAT <= flagA;
		end
// next-state logic and output logic 
	always @* 
	begin
		state_next = state_reg; 
		//datomin = minutos;
		AD = A_DT;
		Direccion = DireccionT0;
		WR = W_RT;
//		flag = flagprincipalT;
		flagA = flagAT;
		flagD = flagDT;
			case (state_reg) 
				s0: begin
					if (LEFT) begin
						enableS = 1'b1;
						enableM = 1'+b0;
						enableH = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
					else if (RIGHT) begin
						enableM = 1'b1;
						enableH = 1'b0;
						enableS = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
					else begin
						enableH = 1'b1;
						enableS = 1'b0;
						enableM = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
				end	
				s1: begin
					if (LEFT) begin
						enableH = 1'b1;
						enableS = 1'b0;
						enableM = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
				end
					else if (RIGHT) begin
						enableS = 1'b1;
						enableM = 1'b0;
						enableH = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
					else begin
						enableM = 1'b1;
						enableH = 1'b0;
						enableS = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
				end	
				s2:
				begin
					if (LEFT) begin
						enableM = 1'b1;
						enableH = 1'b0;
						enableS = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
					else if (RIGHT) begin
						enableH = 1'b1;
						enableS = 1'b0;
						enableM = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
					else begin
						enableS = 1'b1;
						enableM = 1'b0;
						enableH = 1'b0;
						state_next =s3;
						flag = 1'b0;
						flagD = 1'b0;
						flagA = 1'b0;
					end
				end
				s3: begin
					if (flagH0&&enableH) begin
						if (flagHA0 == 1'b1) begin
							state_next= s4;
							Direccion = DireccionH0;
							WR = W_RH;
							AD = A_DH;
							flag = 1'b1;
							flagD = 1'b1;
							flagA = 1'b0;
						end
						else if (flagHA0 == 1'b0) begin
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
							if (flagS0&&enableS) begin
								if (flagSA0 == 1'b1) begin
									state_next= s4;
									Direccion = DireccionS0;
									WR = W_RS;
									AD = A_DS;
									flag = 1'b1;
									flagD = 1'b1;
									flagA = 1'b0;
								end
								else if (flagSA0 == 1'b0) begin
									state_next = s3;
								end
							end
						end
					end
				end
				s4: begin
					if (flagH0&&enableH) begin
						if (flagHD0== 1'b1) begin
							state_next= s0;
							Direccion = DireccionH0;
							AD =W_RH;
							WR = A_DH;
							flag = 1'b1;
							flagD = 1'b0;
							flagA = 1'b1;
						end
						else if (flagHD0 == 1'b0) begin
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
							if (flagS0&&enableS) begin
								if (flagSD0== 1'b1) begin
								state_next= s2;
								Direccion = DireccionS0;
								AD =W_RS;
								WR = A_DS;
								flag = 1'b1;
								flagD = 1'b0;
								flagA = 1'b1;
							end
							else if (flagSD0 == 1'b0) begin
								state_next = s4;
							end			
						end
					end
				end
				end
				default begin
					state_next= s0;
				end
				endcase
		end
endmodule
