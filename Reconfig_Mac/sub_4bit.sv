`timescale 1ns/1ps

module full_sub (
    input logic A, B, Cin,
    output logic Sum, Cout
    );
    assign Sum = A ^ B ^ Cin;
    assign Cout = ((A ^ B) & Cin) | (A & B);
endmodule

module sub_4bit(
    input logic [3:0] A, B,
    output logic [3:0] S
    );
    logic [3:0] B_xor;
    logic C0,C1,C2,C3;
    assign B_xor = B ^ 4'b1111;  
    
    full_sub FS0 (.A(A[0]), .B(B_xor[0]), .Cin(1'b1), .Sum(S[0]), .Cout(C0));
    full_sub FS1 (.A(A[1]), .B(B_xor[1]), .Cin(C0), .Sum(S[1]), .Cout(C1));
    full_sub FS2 (.A(A[2]), .B(B_xor[2]), .Cin(C1), .Sum(S[2]), .Cout(C2));
    full_sub FS3 (.A(A[3]), .B(B_xor[3]), .Cin(C2), .Sum(S[3]), .Cout(C3));
    
endmodule