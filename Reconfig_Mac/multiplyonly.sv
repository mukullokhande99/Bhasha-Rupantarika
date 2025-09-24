`timescale 1ns / 1ps

module rmme2 (
input logic [1:0] A, //Input M1 /E1
input logic [1:0] B, //Input M2 /E2
output logic [3:0] pp, // M1*M2
output logic [1:0] EMax, //Eout= max(E1,E2)
output logic [1:0] OE1, //Emax-E1 (M1>>OE1)
output logic [1:0] OE2); //Emax-E2 (M2>>OE2)

logic ab, cd;
logic blc, adl, ablc, adlc;
logic bc, ad;
logic adlcl, ald, aldocd;

assign ab = A[0] & A[1];
assign cd = B[0] & B[1];

assign blc = (~A[0]) & B[1];
assign adl = A[1] & (~B[0]);
assign ablc= A[1] & blc;
assign adlc= adl & B[1];

assign bc = A[0] & B[1];
assign ad = A[1] & B[0];

assign adlcl= adl & (~B[1]);
assign ald = (~A[1]) & B[0];
assign aldocd = ald | cd;

assign pp[3]= ab & cd;
assign pp[2]= ablc | adlc;
assign pp[1]= ((~ad) & bc) | ((~bc) & ad) ;
assign pp[0]= A[0] & B[0];

endmodule