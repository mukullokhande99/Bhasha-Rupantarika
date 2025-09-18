`timescale 1ns/1ps


module sub_8bit(
input logic [7:0] A, B,
output logic [7:0] S
);
logic [7:0] B_xor;
logic C0,C1,C2,C3,C4,C5,C6;
assign B_xor = B ^ 8'b11111111;  //change

full_sub FA0 (.A(A[0]), .B(B_xor[0]), .Cin(1'b1), .Sum(S[0]), .Cout(C0));
full_sub FA1 (.A(A[1]), .B(B_xor[1]), .Cin(C0), .Sum(S[1]), .Cout(C1));
full_sub FA2 (.A(A[2]), .B(B_xor[2]), .Cin(C1), .Sum(S[2]), .Cout(C2));
full_sub FA3 (.A(A[3]), .B(B_xor[3]), .Cin(C2), .Sum(S[3]), .Cout(C3));
full_sub FA4 (.A(A[4]), .B(B_xor[4]), .Cin(C3),.Sum(S[4]), .Cout(C4));
full_sub FA5 (.A(A[5]), .B(B_xor[5]), .Cin(C4), .Sum(S[5]), .Cout(C5));
full_sub FA6 (.A(A[6]), .B(B_xor[6]), .Cin(C5), .Sum(S[6]), .Cout(C6));
full_adder FA7 (.A(A[7]), .B(B_xor[7]), .Cin(C6),.Sum(S[7]), .Cout(S[8]));

endmodule