`timescale 1ns / 1ps

module asub(
    input logic [7:0]A,B,
    input logic addsub,Cin,
    output logic [7:0]sum,
    output logic Cout
    );
    logic [8:0]s;
    
    assign Ceff = addsub^addsub;
    add_sub x0(
        .A(A),
        .B(B),
        .addsuben(Ceff),
        .S(s)
        );
    assign sum = s[7:0];
    assign Cout = s[8];
endmodule

module csla_16bit(
    input logic [15:0]A,B,
    input addsub,Cin,
    output logic [15:0]sum,
    output logic cout 
    );
    
    logic [7:0]a_low,b_low;
    logic [7:0]a_high,b_high;
    logic [8:0]s_low,s_high0,s_high1;
    logic c_low,c_high0,c_high1;
    
    assign a_low = A[7:0];
    assign b_low = B[7:0];
    assign a_high = A[15:8];
    assign b_high = B[15:8];
    
    
    always_comb
        begin
            sum[7:0] = s_low;
            
            sum[15:8] = c_low ? s_high1:s_high0;
            cout = c_low ? c_high1:c_high0;
        end
    
    //low bits
    asub p0(
        .A(a_low),
        .B(b_low),
        .addsub(addsub),
        .Cin(Cin),
        .S(s_low),
        .Cout(c_low)
        );
    
    //high 0
    asub p1(
        .A(a_high),
        .B(b_high),
        .addsub(addsub),
        .Cin(1'b0),
        .S(s_high0),
        .Cout(c_high0)
        );
    
    //high1    
    asub p2(
        .A(a_high),
        .B(b_high),
        .addsub(addsub),
        .Cin(1'b1),
        .S(s_high1),
        .Cout(c_high1)
        );
endmodule
