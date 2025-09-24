`timescale 1ns / 1ps

module bfb_4bit(
    input logic [3:0] A,
    input logic [3:0] B,
    input logic exp,
    output logic [7:0] pp,
    output logic [3:0] Emax,
    output logic [3:0] D1,
    output logic [3:0] D2
    );
    
    logic [1:0] A0, B0;
    logic [1:0] A1, B1;
    logic [1:0] A2, B2;
    logic [1:0] A3, B3;
    logic [3:0] pp0,pp1,pp2,pp3;
    logic [1:0] Em0,Em3;
    logic [1:0] oe10,oe13;
    logic [1:0] oe20,oe23;
    logic [7:0] A4, B4;
    logic [7:0] A5, B5;
    
    logic [8:0] S0,S1;
    
    always_comb
    begin
        if(~exp)
            begin
            A0 = A[1:0];
            B0 = B[1:0];
            
            A1 = A[3:2];
            B1 = B[1:0];
            
            A2 = A[1:0];
            B2 = B[3:2];
            
            A3 = A[3:2];
            B3 = B[3:2];
            
            A4 = {pp3, pp0};
            B4 = S1[7:0];
            
            A5 = {2'b0, pp1, 2'b0};
            B5 = {2'b0, pp2, 2'b0};  
            
            pp= S0[7:0];
            
            end
            
        else
        begin
            A3 = A[3:2];
            B3 = B[3:2];
            
            A0 = A[1:0];
            B0 = B[1:0];
            
            A4 = {4'b0, A};
            B4 = {4'b0, B};
            
            A5 = {4'b0, B};
            B5 = {4'b0, A};
            
            if (oe13 == 2'b0 & oe23 == 2'b0)
            begin
                Emax = {Em3,Em0};
                D1 = {2'b0,oe10};
                D2 = {2'b0,oe20};
            end
        
            else
            begin
                Emax = (oe13 == 2'b00)? A: B;
                D1= (oe13 == 2'b00)? 4'b0: S1;
                D2= (oe13 == 2'b00)? S0: 4'b0;
            end
               
         end
    end
    
rmm2ec block0 (
.A(A0),
.B(B0),
.pp(pp0),
.EMax(Em0),
.OE1(oe10),
.OE2(oe20));

rmme2 block1 (
.A(A1),
.B(B1),
.pp(pp1)
);

rmme2 block2 (
.A(A2),
.B(B2),
.pp(pp2)
);

rmm2ec block3 (
.A(A3),
.B(B3),
.pp(pp3),
.EMax(Em3),
.OE1(oe13),
.OE2(oe23)
);

add_sub add0 (
.A(A4),
.B(B4),
.addsuben(exp?1'b1:1'b0),
.S(S0)
);

add_sub add1 (
.A(A5),
.B(B5),
.addsuben(exp?1'b1:1'b0),
.S(S1)
);
endmodule
