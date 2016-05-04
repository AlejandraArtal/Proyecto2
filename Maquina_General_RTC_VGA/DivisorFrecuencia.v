`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:02:03 04/14/2016 
// Design Name: 
// Module Name:    DivisorFrecuencia 
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
module divisor_de_frecuecia(clk,clk_out);
    input clk;
    output reg clk_out;
    reg rst;
    reg [25:0] counter;

initial
rst=0;

    always @(posedge clk or negedge rst)
    begin
      if(!rst)
       begin
       rst<=1;
       counter<=26'd0;
       clk_out <= 1'b0;
       end
     else
       if(counter==26'd49_999_999) //va convertir un clk de 100mhz a un mhz
         begin
         counter<=26'd0;
         clk_out <= ~clk_out;
         end
      else
       begin
       counter<=counter+1;
       end
   end
endmodule
