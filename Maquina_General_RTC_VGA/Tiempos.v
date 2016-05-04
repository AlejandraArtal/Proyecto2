`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:13:01 04/11/2016 
// Design Name: 
// Module Name:    Tiempos 
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
module clk_gen ();
  reg clk, reset; 
   
  initial begin
    $monitor ("TIME = %g RESET = %b CLOCK = %b", $time, reset, clk);
    clk = 0; 
    reset = 0; 
    #2  reset = 1; 
    #5  reset = 0; 
    #10  $finish;
  end 
  always 
     #1  clk =  ! clk; 
endmodule
