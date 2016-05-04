`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:17 04/03/2016 
// Design Name: 
// Module Name:    MaquinaPrincipal 
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
module MaquinaPrincipal( 
		input wire reset,UPP, clk, DOWNP, LEFTP,RIGHTP,inter1, inter2, inter3,inter4,
		inout [7:0] DatoDir,
		output reg A_D, R_D,W_R, C_S,
		output wire dclk, //dclk equivalente a CS
		output wire [2:0] red,
		output wire [2:0] green,
		output wire [1:0] blue,
		output wire hsync, vsync,
		input wire alarma_signal,
		output wire [9:0] pixel_x, pixel_y,
		output wire cien
    );
// los comandos inter son los provenientes de los interruptores 
reg flagL,RD, WR, AD, CS;
reg [7:0] DatoDirg, DatoDirPrev, DatoDirIn, DatoBasura;
reg [7:0] DatoHoraT, DatoMinT, DatoSegT, DatoHoraC,DatoMinC, DatoSegC, DatoDia, DatoMes, DatoYear = 0;//guardar os valores de lectura
reg LecEsc;
wire [7:0] DatoTiempoOut,DatoFechaOut, DatoCronometroOut;
wire  flagprincipalTP,flagprincipalFP, flagprincipalCP, A_DTP,
		A_DFP, A_DCP,W_RTP, W_RFP, W_RCP, flagAT0, flagDT0; 
assign cien = clk;
reg flagLectura, FlagEscritura, EnableLeer;

// Instantiate the module
clockdiv clockdiv (
    .clk(clk), 
    .dclk(dclk)
    );

// Instantiate the module
MaquinaTiempo instance_Tiempo (
    .enableT(inter1), 
    .clk(dclk), 
    .reset(reset), 
    .UP(UPP), 
    .DOWN(DOWNP), 
    .LEFT(LEFTP), 
    .RIGHT(RIGHTP), 
    .DireccionIN(DatoDir), 
    .DireccionT0(DatoTiempoOut), 
    //.flagprincipalT(flagprincipalTP),
	 .flagDT(flagDT0),
	 .flagAT(flagAT0),
    .A_DT(A_DTP), 
    .W_RT(W_RTP)
    );

// Instantiate the module
MaquinaFecha instance_Fecha (
    .enableF(inter2), 
    .clk(dclk), 
    .reset(reset), 
    .UP(UPP), 
    .DOWN(DOWNP), 
    .LEFT(LEFTP), 
    .RIGHT(RIGHTP), 
    .DireccionIN(DatoDir), 
    .DireccionF0(DatoFechaOut), 
    //.flagprincipalF(flagprincipalFP), 
	 .flagDF(flagDF0),
	 .flagAF(flagAF0),
    .A_DF(A_DFP), 
    .W_RF(W_RFP)
    );

// Instantiate the module
MaquinaCronometro instance_Cronometro (
    .enableC(inter3), 
    .clk(dclk), 
    .reset(reset), 
    .UP(UPP), 
    .DOWN(DOWNP), 
    .LEFT(LEFTP), 
    .RIGHT(RIGHTP), 
    .DireccionIN(DatoDir), 
    .DireccionC0(DatoCronometroOut), 
    //.flagprincipalC(flagprincipalCP),
	 .flagAC(flagAC0),
	 .flagDC(flagDC0),
    .A_DC(A_DCP), 
    .W_RC(W_RCP)
    );

mainModule VGA_controlador (
    .clk(dclk), 
    .reset(reset), 
    .cambio_dia(DatoDia), 
    .cambio_mes(DatoMes), 
    .cambio_year(DatoYear), 
    .hora_t(DatoHoraT), 
    .hora_c(DatoHoraC), 
    .min_t(DatoMinT), 
    .min_c(DatoMinC), 
    .seg_t(DatoSegT), 
    .seg_c(DatoSegC), 
    .alarma_signal(alarma_signal), 
    .hsync(hsync), 
    .vsync(vsync), 
    .pixel_x(pixel_x), 
    .pixel_y(pixel_y), 
    .red(red), 
    .green(green), 
    .blue(blue)
    );

	 
// symbolic state declaration 
localparam [5:0] s0 = 7'b000000,s1 = 7'b000001,s2 = 7'b000010, s3 = 7'b000011, s4= 7'b000100, s5= 7'b000101, s6 = 7'b000110, 
				s7 = 7'b000111, s8= 7'b001000,s9= 7'b001001, s10 = 7'b001010,s11 = 7'b001011,s12 = 7'b001100,s13 = 7'b001101,
				s14 = 7'b001110,s15 = 7'b001111,s16 = 7'b010000,s17 = 7'b010001,s18 = 7'b010010,s19 = 7'b010011,s20 = 7'b010100,
				s21 = 7'b010101,s22 = 7'b010110,s23 = 7'b010111,s24 = 7'b011000,s25 = 7'b011001,s26 = 7'b011010, s27 = 7'b11011,
				s28 = 7'b11100, s29 = 7'b11101, s30= 7'b011110, s31= 7'b11111,s32= 7'b100000,s33= 7'b100001,s34= 7'b100010,s35= 7'b100011,
				s36= 7'b100100, s37=7'b100101 , s38 =7'b100110 ,s39=7'b100111, s40 =7'b101000, s41=7'b101001, s42 =7'b101010, s43=7'b101011, s44=7'b101100, s45=7'b101101,
				s46= 7'b101110,s47=7'b101111, s48=7'b110000, s49=7'b110001,s50=7'b110010 ,s51=7'b110011, s52=7'b110100, s53= 7'b110101,
				s54= 7'b110110, s55= 7'b110111, s56= 7'b111000, s57 = 7'b111001, s58 = 7'b111010, s59= 7'b111011, s60= 7'b111100,
				s61 = 7'b111101, s62 = 7'b111110, s63 = 7'b 111111, s64= 7'b1000000,s65 = 7'b1000001, s66=7'b1000010, s67=7'b1000011, s68=7'b1000100, s69 =7'b1000101, 
				s70 = 7'b1000110, s71= 7'b1000111, s72= 7'b1001000, s73 = 7'b1001001, s74= 7'b1001010, s75= 7'b1001011, s76= 7'b1001100, s77= 7'b1001101, s78 = 7'b1001110;
// signal declaration 
	reg [6:0] state_reg , state_next ;
	reg [6:0] contador = 6'b0;
// state register
	always @(posedge dclk, posedge reset) 
		if (reset) begin
			state_reg <= s40;
			A_D <= 8'b0;
			W_R <= 1'b0;
			R_D <= 1'b0;
			C_S <= 1'b0;
			DatoDirIn <= 8'b0;
			end
		else begin
			state_reg <= state_next;			
			A_D <= AD;
			W_R <= WR;
			R_D <= RD;
			C_S <= CS;
			DatoDirPrev <= DatoDirg;
			DatoDirIn <= DatoDir;
		end
	always @ (posedge dclk, posedge reset)
		if (reset) begin
			DatoDirIn <= 8'b0;
		end
		else if (EnableLeer) begin
			DatoDirIn <= DatoDir;
		end
		else begin
			DatoDirIn<= 8'bz;
		end
// next-state logic and output logic 
	always @ * begin
			state_next = state_reg; 
			case (state_reg)
				40:begin // darle tiempo a AD
					if (contador < 6'b1011) begin
						AD= 1'bz;
						state_next= s40;
						DatoDirg = 8'bz;
						LecEsc = 1'bz;
						WR = 1'b1;
						RD = 1'b1;
						CS = 1'b1;
						contador = contador + 1'b1;
					end
					else if ((contador == 6'b1011) | | (contador > 6'b1011) ) begin
						AD= 1'b0;
						state_next= s0;
						DatoDirg = 8'bz;
						LecEsc = 1'bz;
						WR = 1'b1;
						RD = 1'b1;
						CS = 1'b1;
						contador = 6'b0;
					end
				end
				s0: begin// Asigna la dirección en la que se inicializa el RTC
					if (contador < 6'b0110) begin // tiempo de 50 ns
						state_next = s0;
						AD = 1'b0;
						DatoDirg = 8'hz;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador= contador +1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100) ) begin //tiempo de 50 ns
						state_next = s0;
						contador= contador +1'b1;
						AD = 1'b0;
						DatoDirg = 8'h2;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
					end
					else if (contador == 6'b1100) begin
						state_next = s41;
						AD = 1'b1;
						DatoDirg = 8'h2;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end 
				s41: begin// RELLENOOOOOO 2, tiempo AD 10ns
					if (contador < 6'b1010) begin// mantener el tiempo en 100ns
						state_next = s41;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = contador + 1'b1;
					end
					else begin// sino se mantiene el tiempo se pasa al siguiente estado
						state_next = s1;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s1: begin// inicializa en add. 2 bit 4 en 1
					if (contador < 6'b0110) begin
						state_next = s1;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador +1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100) ) begin
						state_next = s1;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'b00001000;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador +1'b1;
					end
					else begin
						state_next = s42;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'b00010000;//00001000
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end
				s42:begin// RELLEEENOOO 2, tiempo AD
					if (contador < 6'b1011) begin
						state_next = s42;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s71;
						AD = 1'b0;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s71: begin// Asigna la dirección en la que se inicializa el RTC
					if (contador < 6'b0110) begin // tiempo de 50 ns
						state_next = s71;
						AD = 1'b0;
						DatoDirg = 8'hz;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador= contador +1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100) ) begin //tiempo de 50 ns
						state_next = s71;
						contador= contador +1'b1;
						AD = 1'b0;
						DatoDirg = 8'h2;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
					end
					else begin
						state_next = s70;
						AD = 1'b1;
						DatoDirg = 8'h2;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end 
				s70:begin// tiempo AD
					if (contador < 6'b0110) begin
						state_next = s70;
						AD = 1'b1;
						LecEsc = 1'bz;
						DatoDirg = 8'bz;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin 
						state_next = s2;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'b00000000;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = contador + 1'b1;
					end
				end
				s2:begin// inicialza en add. 2 bit 4 en 0, tiempos escritura dato
					if (contador < 6'b0110) begin
						state_next = s2;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100) ) begin 
						state_next = s2;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'b00000000;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s43;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'b00000000;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end
				s43: begin // RELLENOOOO 2, tiempo AD
					if (contador < 6'b1011) begin
						state_next = s43;
						AD = 1'b1;
						DatoDirg = 8'hz;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = contador +1'b1;
					end
					else begin
						state_next = s37;
						AD = 1'b0;
						DatoDirg = 8'hz;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s37: begin// Direccion Digital Trimming, Tiempo introducir direcciòn
					if (contador < 6'b110) begin
						state_next = s37;
						AD = 1'b0;
						DatoDirg = 8'hz;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110))&& (contador < 6'b1100) ) begin
						state_next = s37;
						AD = 1'b0;
						DatoDirg = 8'h16;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s44;
						AD = 1'b1;
						DatoDirg = 8'h16;
						LecEsc = 1'b1;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end
				s44: begin // tiempo AD
					if (contador < 6'b1011) begin
						state_next = s44;
						AD = 1'b1;
						DatoDirg = 8'dz;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s38;
						AD = 1'b1;
						DatoDirg = 8'dz;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s38: begin // dato en D2 para el digital trimming, tiempo introducir dato
					if (contador < 6'b110) begin
						state_next = s38;
						AD = 1'b1;
						DatoDirg = 8'dz;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100)) begin
						state_next = s38;
						AD = 1'b1;
						DatoDirg = 8'd45;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s71;
						AD = 1'b1;
						DatoDirg = 8'd45;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end
				s71: begin// tiempo AD
					if (contador < 6'b1011) begin
						AD = 1'b1;
						WR = 1'b1;
						RD = 1'b1;
						DatoDirg = 8'bz;
						CS =1'b1;
						LecEsc = 1'b0;
						contador = contador + 1'b1;
						state_next = s71;
					end
					else begin
						AD = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						DatoDirg = 8'bz;
						LecEsc= 1'b0;
						CS =1'b1;
						contador = 6'b0;
						state_next = s63;
					end
				end
				s63: begin// Direccion en 00 para ingresar el valor del frecuency tuning
					if (contador < 6'b110) begin
						state_next = s63;
						AD = 1'b0;
						DatoDirg = 8'hz;
						LecEsc = 1'bz;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110))&& (contador < 6'b1100) ) begin
						state_next = s63;
						AD = 1'b0;
						DatoDirg = 8'h0;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s64;
						AD = 1'b1;
						DatoDirg = 8'h0;
						LecEsc = 1'b1;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end
				s64: begin// tiempo AD
					if (contador < 6'b1011) begin
						AD = 1'b1;
						WR = 1'b1;
						RD = 1'b1;
						DatoDirg = 8'bz;
						LecEsc = 1'b0;
						CS =1'b1;
						contador = contador + 1'b1;
						state_next = s64;
					end
					else begin
						AD = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						DatoDirg = 8'bz;
						LecEsc = 1'b0;
						CS =1'b1;
						contador = 6'b0;
						state_next = s67;
					end
				end
				s67: begin // ingresar Dato en cero en el frecuency tuning
					if (contador < 6'b110) begin
						state_next = s67;
						AD = 1'b1;
						DatoDirg = 8'dz;
						LecEsc = 1'bz;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100)) begin
						state_next = s67;
						AD = 1'b1;
						DatoDirg = 8'd0;
						LecEsc = 1'b0;
						WR = 1'b0;
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s45;
						AD = 1'b1;
						DatoDirg = 8'd0;
						LecEsc = 1'b0;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
					end
				end
				s45: begin // RELLENOOO 2, tiempo AD
					if (contador < 6'b1011) begin
						state_next = s45;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;// ahora estará la información en la memoria para utilizarse
						RD = 1'b1;
						CS =1'b1;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s3;
						AD = 1'b0;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;// ahora estará la información en la memoria para utilizarse
						RD = 1'b1;
						CS =1'b1;
						contador = 1'b0;
					end
				end
				s3:begin // ingreso de comando de transferencia para ingresar a memoria de tiempo a leer datos
					if (contador < 6'b110) begin
						state_next = s3;
						AD = 1'b0;
						LecEsc = 1'bz;
						DatoDirg = 8'dz;
						WR = 1'b0;// ahora estará la información en la memoria para utilizarse
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110))&& (contador < 6'b1100))  begin
						state_next = s3;
						AD = 1'b0;
						LecEsc = 1'b0;
						DatoDirg = 8'd240;
						WR = 1'b0;// ahora estará la información en la memoria para utilizarse
						RD = 1'b1;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s69;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'd240;
						WR = 1'b1;// ahora estará la información en la memoria para utilizarse
						RD = 1'b1;
						CS =1'b1;
					end
				end
				s69: begin
					if (contador < 6'b1011) begin
						state_next = s69;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;// ahora estará la información en la memoria para utilizarse
						RD = 1'b1;
						CS =1'b1;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s66;
						AD = 1'b1;
						LecEsc = 1'b0;
						DatoDirg = 8'bz;
						WR = 1'b1;// ahora estará la información en la memoria para utilizarse
						RD = 1'b1;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s66: begin // Despues del comando de transferencia lee un dato
					if (contador < 6'b110) begin
						state_next = s66;
						AD = 1'b1;
						DatoDirg = 8'dz;
						LecEsc = 1'b1;
						WR = 1'b1;
						RD = 1'b0;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador >6'b110 | | contador ==6'b110 )&& contador < 6'b1011)) begin
						state_next = s66;
						AD = 1'b1;
						DatoBasura = DatoDirIn;
						LecEsc = 1'b1;
						WR = 1'b1;
						RD = 1'b0;
						CS =1'b0;
						EnableLeer = 1'b1;
						contador = contador +1'b1;
					end
					else begin
						state_next = s52;  ////// SALTOOOOOO (original 52)
						AD = 1'b1;
						DatoBasura = DatoDirIn;
						LecEsc = 1'b1;
						WR = 1'b1;
						RD = 1'b1;
						CS =1'b1;
						contador = 6'b0;
						EnableLeer = 1'b1;
					end
				end
				s52:begin //dirección de día./// tiempo AD
					if (contador < 6'b1011) begin
						state_next = s52;
						AD = 1'b0;
						LecEsc = 1'bz;
						RD = 1'b1;
						WR = 1'b1;
						DatoDirg = 8'hz;
						CS =1'b1;
						contador = contador +1'b1;
					end
					else begin
						state_next = s4;
						AD = 1'b0;
						LecEsc = 1'bz;
						RD = 1'b1;
						WR = 1'b1;
						DatoDirg = 8'hz;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s4:begin //dirección de día, tiempo leer direccion
					if (contador < 6'b110) begin
						state_next = s4;
						AD = 1'b0;
						LecEsc = 1'bz;
						RD = 1'b0;
						WR = 1'b0;
						DatoDirg = 8'hz;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100)) begin
						state_next = s4;
						AD = 1'b0;
						LecEsc = 1'b0;
						RD = 1'b0;
						WR = 1'b0;
						DatoDirg = 8'h24;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s46;
						AD = 1'b1;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b1;
						DatoDirg = 8'h24;
						CS =1'b1;
					end
				end
				s46:begin///relleno AD, tiempo AD
					if (contador < 6'b1011) begin
						AD= 1'b1;
						LecEsc = 1'bz;
						RD = 1'b1;
						WR = 1'b1;
						//DatoDia = DatoDir; // se guarda el valor de dia presente en la direccion
						state_next = s5;
						CS =1'b1;
						contador = contador +1'b1;
					end
					else begin
						AD= 1'b1;
						LecEsc = 1'bz;
						RD = 1'b1;
						WR = 1'b1;
						state_next = s5;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s5:begin//Obtencion Dia, tiempo leer dato
					if ((contador < 6'b110)) begin
						state_next = s5;
						AD = 1'b1;
						LecEsc = 1'bz;
						RD = 1'b0;
						WR = 1'b1;
						DatoDia = 8'bz; // se guarda el valor de dia presente en la dirección
						CS =1'b0;
						contador = contador + 1'b1;
						EnableLeer = 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1100)) begin
						state_next = s5;
						AD = 1'b1;
						LecEsc = 1'b1;
						RD = 1'b0;
						WR = 1'b1;
						DatoDia = DatoDirIn; // se guarda el valor de dia presente en la dirección
						CS =1'b0;
						contador = contador + 1'b1;
						EnableLeer = 1'b1;
					end
					else begin
						state_next = s47;
						AD = 1'b1;
						LecEsc = 1'b1;
						RD = 1'b1;
						WR = 1'b1;
						DatoDia = DatoDirIn; // se guarda el valor de dia presente en la dirección
						EnableLeer = 1'b1;
						CS =1'b1;
					end
				end
				s47:begin///relleno AD, tiempo AD
					if (contador < 6'b1011) begin
						AD = 1'b0;
						LecEsc = 1'bz;
						RD = 1'bz;
						WR = 1'bz;
						DatoDirg = 8'hz;
						flagL = 1'bz;
						state_next= s47;
						CS =1'bz;
						contador = contador +1'b1;
					end
					else begin
						AD = 1'b0;
						LecEsc = 1'bz;
						RD = 1'bz;
						WR = 1'bz;
						DatoDirg = 8'hz;
						flagL = 1'bz;
						state_next= s6;
						CS =1'bz;
						contador = 6'b0;
					end
				end
				s6:begin//Direccion de mes
					state_next = s48;
					AD = 1'b0;
					LecEsc = 1'b0;
					RD = 1'b0;
					WR = 1'b0;
					DatoDirg = 8'h25;
					//flagL = 1'b0;
					CS =1'b0;
				end
				s48:begin///relleno AD
					AD= 1'b1;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoMes = DatoDir;
					flagL = 1'bz;
					state_next = s7;
					CS =1'b1;
				end
				s7:begin//Obtención de mes
					AD = 1'b1;
					LecEsc = 1'b1;
					RD = 1'b1;
					WR = 1'b0;
					DatoMes = DatoDirIn;
					state_next = s49;
					CS =1'b0;
				end
				s49:begin///relleno AD
					AD= 1'b0;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					//DatoDirg = 8'h26;
					state_next = s8;
					CS =1'bz;
				end
				s8:begin// Direccion Año
					state_next = s50;
					AD = 1'b0;
					LecEsc = 1'b0;
					RD = 1'b0;
					WR = 1'b0;
					DatoDirg = 8'h26;
					//flagL = 1'b0;
					CS =1'b0;
				end
				s50:begin
					state_next = s9;//relleno
					AD = 1'b1;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoYear = 8'hz;
					//flagL = 1'b0;
					CS =1'b1;
				end
				s9:begin
					state_next = s51;//Obtención Year
					AD = 1'b1;
					LecEsc = 1'b1;
					RD = 1'b1;
					WR = 1'b0;
					DatoYear = DatoDirIn;
					//flagL = 1'b0;
					CS =1'b0;
				end
				s51:begin//Dirección Hora tiempo///////////////////////////////////////////////
					state_next = s10;
					AD = 1'b0;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoDirg = 8'hz;
					//flagL = 1'b0;
					CS =1'bz;
				end
				s10:begin//Dirección Hora tiempo
					state_next = s52;
					AD = 1'b0;
					LecEsc = 1'b0;
					RD = 1'b0;
					WR = 1'b0;
					DatoDirg = 8'h23;
					//flagL = 1'b0;
					CS =1'b0;
				end
				s52:begin//Obtención Hora Tiempo
					state_next = s11;
					AD = 1'b1;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoHoraT = 8'bz;
					//flagL = 1'b0;
					CS =1'b1;
				end
				s11:begin//Obtención Hora Tiempo
					state_next = s53;
					AD = 1'b1;
					LecEsc = 1'b1;
					RD = 1'b1;
					WR = 1'b0;
					DatoHoraT = 8'h17;
					//flagL = 1'b0;
					CS =1'b0;
				end
				s53:begin//Dirección Minutos tiempo
					state_next = s12;
					AD = 1'b0;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoDirg = 8'hz;
					//flagL = 1'b0;
					CS =1'bz;
				end
				s12:begin//Dirección Minutos tiempo
					state_next = s54;
					AD = 1'b0;
					LecEsc = 1'b0;
					RD = 1'b0;
					WR = 1'b0;
					DatoDirg = 8'h22;
					//flagL = 1'b0;
					CS =1'b0;
				end
				s54:begin//Obtención minutos Tiempo, tiempo AD
					state_next = s13;
					AD = 1'b1;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoMinT = 8'bz;
					//flagL = 1'b0;
					CS =1'b1;
				end
				s13:begin//Obtención minutos Tiempo
					state_next = s55;
					AD = 1'b1;
					LecEsc = 1'b1;
					RD = 1'b1;
					WR = 1'b0;
					DatoMinT = DatoDirIn;
					//flagL = 1'b0;
					CS =1'b0;
				end
				s55:begin//Dirección segundos tiempo, tiempo AD
					state_next = s72;
					AD = 1'b0;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoDirg = 8'hz;
					flagL = 1'bz;
					CS =1'bz;
				end
				s72: begin//tiempo AD
					if (contador < 6'b1011) begin
						state_next = s72;
						AD = 1'b1;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b1;
						DatoSegT = 8'bz;
						//flagL = 1'b0;
						CS =1'b1;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s14;
						AD = 1'b1;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b1;
						DatoSegT = 8'bz;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s14:begin//Dirección segundos tiempo
					if (contador < 6'b110) begin
						state_next = s14;
						AD = 1'b0;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b0;
						DatoDirg = 8'hz;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1011)) begin
						state_next = s14;
						AD = 1'b0;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b0;
						DatoDirg = 8'h21;
						CS =1'b0;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s56;
						AD = 1'b1;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b1;
						DatoDirg = 8'h21;
						CS =1'b1;
					end	
				end
				s56:begin//tiempo AD
					if (contador < 6'b1011) begin
						state_next = s56;
						AD = 1'b1;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b1;
						DatoSegT = 8'bz;
						//flagL = 1'b0;
						CS =1'b1;
						contador = contador + 1'b1;
					end
					else begin
						state_next = s15;
						AD = 1'b1;
						LecEsc = 1'b0;
						RD = 1'b1;
						WR = 1'b1;
						DatoSegT = 8'bz;
						CS =1'b1;
						contador = 6'b0;
					end
				end
				s15:begin//Obtención segundos Tiempo
					if (contador < 6'b110) begin
						state_next = s15;
						AD = 1'b1;
						LecEsc = 1'bz;
						RD = 1'b0;
						WR = 1'b1;
						DatoSegT = 8'bz;
						CS =1'b0;
						contador = contador + 1'b1;
						EnableLeer = 1'b1;
					end
					else if (((contador == 6'b110) | | (contador > 6'b110)) && (contador < 6'b1011)) begin
						state_next = s15;
						AD = 1'b1;
						LecEsc = 1'b1;
						RD = 1'b0;
						WR = 1'b1;
						DatoSegT = DatoDirIn;
						CS =1'b0;
						contador = contador + 1'b1;
						EnableLeer = 1'b1;
					end
					else begin
						state_next = s72; /// salto de inicialisación (57 original)
						AD = 1'b1;
						LecEsc = 1'b1;
						RD = 1'b1;
						WR = 1'b1;
						DatoSegT = DatoDirIn;
						CS =1'b1;
						EnableLeer = 1'b1;
					end
				end
				s57:begin//Dirección Hora cronómetro, tiempo AD////////////////////////////////////////
					state_next = s16;
					AD = 1'b0;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoDirg = 8'hz;
					//flagL = 1'b0;
					CS =1'bz;
				end
				s16:begin//Dirección Hora cronómetro, tiempo introducir hora
					state_next = s58;
					AD = 1'b0;
					LecEsc = 1'b0;
					RD = 1'b0;
					WR = 1'b0;
					DatoDirg = 8'h43;
					CS =1'b0;
				end
				s58:begin//Obteción hora cronómetro, tiempo AD
					state_next = s17;
					AD = 1'b1;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoHoraC = 8'bz;
					CS =1'b1;
				end
				s17:begin//Obteción hora cronómetro, tiempo obtener hora
					state_next = s59;
					AD = 1'b1;
					LecEsc = 1'b1;
					RD = 1'b1;
					WR = 1'b0;
					DatoHoraC = DatoDirIn;
					CS =1'b0;
				end
				59:begin//Dirección Minutos cronómetro
					state_next = s18;
					AD = 1'b0;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoDirg = 8'hz;
					CS =1'bz;
				end
				s18:begin//Dirección Minutos cronómetro
					state_next = s60;
					AD = 1'b0;
					LecEsc = 1'b0;
					RD = 1'b0;
					WR = 1'b0;
					DatoDirg = 8'h42;
					CS =1'b0;
				end
				s60:begin//Obtención Minutos cronómetro
					state_next = s19;
					AD = 1'b1;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoMinC = 8'bz;
					CS =1'b1;
				end
				s19:begin//Obtención Minutos cronómetro
					state_next = s61;
					AD = 1'b1;
					LecEsc = 1'b1;
					RD = 1'b1;
					WR = 1'b0;
					DatoMinC = DatoDirIn;
					CS =1'b0;
				end
				s61:begin//Dirección Segundos cronómetro
					state_next = s20;
					AD = 1'b0;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoDirg = 8'hz;
					CS =1'b1;
				end
				s20:begin//Dirección Segundos cronómetro
					state_next = s62;
					AD = 1'b0;
					LecEsc = 1'b0;
					RD = 1'b0;
					WR = 1'b0;
					DatoDirg = 8'h41;
					CS =1'b0;
				end
				s62:begin//Obtención Segundos cronómetro
					state_next = s21;
					AD = 1'b1;
					LecEsc = 1'bz;
					RD = 1'bz;
					WR = 1'bz;
					DatoSegC = 8'bz;
					CS =1'b1;
				end
				s21:begin//Obtención Segundos cronómetro
					state_next = s40;
					AD = 1'b1;
					LecEsc = 1'b1;
					RD = 1'b1;
					WR = 1'b0;
					DatoSegC = DatoDirIn;
				end
				s22:begin// inicio de escritura
					if (inter1 == 1'b1 && flagAT0 == 1'b1)begin
						DatoDirg = DatoTiempoOut;
						AD = A_DTP;
						WR = W_RTP;
						state_next = s23;
					end
					else if (inter1 == 1'b1 && flagAT0 == 1'b0) begin
						state_next = s22;
					end
					else begin
						state_next = s24;
					end
				end
				s23:begin
					if (inter1 == 1'b1 && flagDT0 == 1'b1) begin
						DatoDirg = DatoTiempoOut;
						AD = A_DTP;
						WR = W_RTP;
						state_next = s28;
					end
					else if (inter1 == 1'b1 && flagDT0 == 1'b0) begin
						state_next = s23;
					end
					else begin
						state_next = s0;
					end
				end
				s24: begin if (inter2 == 1'b1 && flagDF0 == 1'b1)begin
						DatoDirg = DatoFechaOut;
						AD = A_DFP;
						WR = W_RFP;
						state_next = s25;
					end
					else if (inter2 == 1'b1 && flagDF0 == 1'b0) begin
						state_next = s24;
					end
					else begin
						state_next = s26;
					end
				end
				s25:begin
					if (inter2 == 1'b1 && flagAF0 == 1'b1) begin
						DatoDirg = DatoFechaOut;
						AD = A_DFP;
						WR = W_RFP;
						state_next = s28;
					end
					else if (inter2 == 1'b1 && flagAF0== 1'b0) begin
						state_next = s25;
					end
					else begin
						state_next = s0;
					end
				end
				s26:begin if (inter3 == 1'b1 && flagAC0 == 1'b1)begin
						DatoDirg = DatoCronometroOut;
						AD = A_DCP;
						WR = W_RCP;
						state_next = s27;
					end
					else if (inter3 == 1'b1 && flagAC0 == 1'b0) begin
						state_next = s26;
					end
					else begin
						state_next = s28;
					end
				end
				s27: begin
					if (inter3 == 1'b1 && flagDC0 == 1'b1) begin
						DatoDirg = DatoCronometroOut;
						AD = A_DCP;
						WR = W_RCP;
						state_next = s28;
					end
					else if (inter3 == 1'b1 && flagDC0 == 1'b0) begin
						state_next = s27;
					end
					else begin
						state_next = s0;
					end
				end
				s28: begin// si se activa el cronómetro
					if (inter4 == 1'b1)begin
						AD = 1'b0;
						RD = 1'b0;
						WR = 1'b0;
						DatoDirg = 8'h0;
						state_next = s29;
					end
					else begin// si el cronómetro está inactivo igualmente lo reescribe como inactivo
						AD = 1'b0;
						RD = 1'b0;
						WR = 1'b0;
						DatoDirg = 8'h0;
						state_next = s30;
					end
				end
				s29: begin// activa el cronómetro
					DatoDirg = 8'b00001000;
					AD = 1'b1;
					WR = 1'b1;
					state_next = s31;
				end
				s30: begin// desactiva el cronómetro
					DatoDirg = 8'h00000000;
					AD = 1'b1;
					WR = 1'b1;
					state_next = s31;
				end
				s31:begin // ingreso de comando de transferencia para que la memoria lea los datos
					state_next = s3;
					AD = 1'b0;
					LecEsc = 1'b0;
					DatoDirg = 8'b11110001;
					WR = 1'b0;// ahora estará la información en la memoria para utilizarse
					RD = 1'b1;
					flagL = 1'b0;
				end
				default begin
					state_next= s40; 
				end
			endcase
		end
		assign DatoDir = (LecEsc) ? 8'bz : DatoDirPrev;
   
endmodule
