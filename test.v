`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2022 16:21:16
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIR_test;
parameter N = 32;
reg clk,clr;
reg [N-1:0] X,h0,h1,h2,d;
wire [N-1:0] Y;
FIR  dut(X,h0,h1,h2,Y,clk,clr,d);
initial begin
clk=0;
clr=1;
h0= 32'd1 ;
h1=32'd2;
h2=32'd1;
X=0;
//d=1500;
d=1100;
//d=300;
//d=70;
#10 clr=0;

//#16 X= 32'd6;
#16 X=5;
//#16 X=11;

#400 $finish;
end


always #5 clk=~clk;


endmodule