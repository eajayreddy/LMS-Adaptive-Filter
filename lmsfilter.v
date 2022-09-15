`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2022 16:20:55
// Design Name: 
// Module Name: lmsfilter
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


module adder(A,B,sum);    //  adder
parameter N=32;
input signed [N-1:0] A;
input signed[N-1:0] B;
output signed [N-1:0] sum;
assign sum=A+B;
endmodule

module multiplier(A,B,sum,clk);   ///multiplier
parameter  N=32;
input signed [N-1:0] A;
input clk;
input signed [N-1:0] B;
output signed [N-1:0] sum;
reg signed [N-1:0]z;
integer i;
always@(posedge clk)
begin
z=0;
for(i=0;i<32;i=i+1)
begin
if (i!=32'd31)
  if(B[i]==1'b1)
    z=z+(A<<i); 
else
    if (B[i]==1'b1)
      z=z-(A<<i);
end
end
assign sum=z;
endmodule




module filtercoeff(clk,clr,h0,h1,h2,p0,p1,p2,k0,k1,k2);           // filter coefficients
parameter N=32;
input clk,clr;
input signed [N-1:0]h0,h1,h2,p0,p1,p2;
output reg signed [N-1:0]k0,k1,k2;
always@(posedge clk)
begin
if(clr==1) begin
 k0<=h0;
 k1<=h1;
 k2<=h2;
end
else begin
    k0<=p0;
    k1<=p1;
    k2<=p2;
     end
end               
endmodule

module Delay(in,out,clk,clr);       // delay blocks
parameter N = 32;
input clk,clr;
input signed [N-1:0] in;
output reg signed [N-1:0] out;
always @(posedge clk) begin
    if(clr)out<=32'b0;
    else out<=in;
end
endmodule

module FIR(X,h0,h1,h2,Y,clk,clr,d);        /// main module
parameter N = 32;
parameter U=10;
input signed [N-1:0] X,h0,h1,h2,d;
input clk,clr;
output signed [N-1:0] Y;
wire signed [N-1:0] D1_out,M1_out,M2_out,D2_out,M3_out,A1_out;
wire signed [N-1:0] k0,k1,k2,p0,p1,p2;
wire signed [N-1:0]error;
filtercoeff   f2(clk,clr,h0,h1,h2,p0,p1,p2,k0,k1,k2);
Delay D1(X,D1_out,clk,clr);
multiplier M1(X,k0,M1_out,clk);
Delay D2(D1_out,D2_out,clk,clr);
multiplier M2(D1_out,k1,M2_out,clk);
multiplier M3(D2_out,k2,M3_out,clk);
adder A1(M1_out,M2_out,A1_out);
adder A2(A1_out,M3_out,Y);

assign error = d-Y;                     // error value
assign p0=k0+((error*X)>>>U);
assign p1=k1+((error*D1_out)>>>U);
assign p2=k2+((error*D2_out)>>>U);
//filtercoeff   f3(clk,clr,h0,h1,h2,p0,p1,p2,k0,k1,k2);
endmodule

