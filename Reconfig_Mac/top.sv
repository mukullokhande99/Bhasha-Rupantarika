`timescale 1ns / 1ps

module top(
    input logic [23:0]A,B,
    input logic [1:0]mode,
    input logic clk, rst,
    output logic [23:0]acc  //output width equals the max pecision, rest bits in other needs to be 0 padded, in simd, net accumulated value
    );
    
    logic [15:0]C;
    logic [3:0] b11,b12,e1;
    logic [3:0] b21,b22,e2;
    logic [3:0] b31,b32,e3;
    logic [3:0] b41,b42,e4;
    logic [3:0] b51,b52,e5;
    logic [3:0] b61,b62,e6;
    logic s1,s2,s3,s4,s5,s6;
    logic [7:0]man_c;
    
    logic [3:0] i11,i12,i21,i22,i31,i32,i41,i42,i51,i52,i61,i62;
    logic [7:0] op1,op2,op3,op4,op5,op6;
    logic [3:0] em1,em2,em3,em4,em5,em6;
    logic [3:0] d11,d12,d21,d22,d31,d32,d41,d42,d51,d52,d61,d62;
    
    always_ff @(posedge clk)
        begin
            if(rst)
                acc = 24'b0;
                
            else
                begin
                    
                     
                    //6 bfb with inputs gated as per the mode signal.
                    
                end
        end
        
     decoder Dec(.A(A), .B(B), .C(C), .mode(mode),
            .b11(b11), .b12(b12), .e1(e1),
            .b21(b21), .b22(b22), .e2(e2),
            .b31(b31), .b32(b32), .e3(e3),
            .b41(b41), .b42(b42), .e4(e4),
            .b51(b51), .b52(b52), .e5(e5),
            .b61(b61), .b62(b62), .e6(e6),
            .s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5), .s6(s6),
            .man_c(man_c));
            
            
     bfb_4bit B1(
        .A(i11),
        .B(i12),
        .exp(e1),
        .pp(op1),
        .Emax(em1),
        .D1(d11),
        .D2(d12)
        );
        
     bfb_4bit B2(
        .A(i21),
        .B(i22),
        .exp(e2),
        .pp(op2),
        .Emax(em2),
        .D1(d21),
        .D2(d22)
        );
        
     bfb_4bit B3(
        .A(i31),
        .B(i32),
        .exp(e3),
        .pp(op3),
        .Emax(em3),
        .D1(d31),
        .D2(d32)
        );
        
     bfb_4bit B4(
        .A(i41),
        .B(i42),
        .exp(e4),
        .pp(op4),
        .Emax(em4),
        .D1(d41),
        .D2(d42)
        );
        
     bfb_4bit B5(
        .A(i51),
        .B(i52),
        .exp(e5),
        .pp(op5),
        .Emax(em5),
        .D1(d51),
        .D2(d52)
        );
        
     bfb_4bit B6(
        .A(i61),
        .B(i62),
        .exp(e6),
        .pp(op6),
        .Emax(em6),
        .D1(d61),
        .D2(d62)
        );
        
     comp_8bit(
        .A(),
        .B(),
        .d51(), .d52(),
        .d61(), .d62(),
        .mode(),
        .Emax()
        );
     
     diff_gen G1(
        .mode(mode),
        .e_bf(), .c_bf(), .max_bf(),          
        .exp1(), .exp2(), .exp3(), .exp4(), .exp5(), .exp6(), .c_fp(), .max_fp(),  
        .dif_bfe(), .dif_bfc(),             
        .dif1(), .dif2(), .dif3(), .dif4(), .dif5(), .dif6(), .difc()  
        );
        
    align_add A1(
        .mode(mode),
        .in1(), .in2(), .in3(), .in4(), .in5(), .in6(),        // ops of bfb 1 2 3 4, partial products
        .c_acc_bf(),                                           // addent value for BF16
        .c_acc_fp(),
        .e_bfmax(),                                            // max exponent for BF16
        .bfe_dif(), .bfc_dif(),                                // exp difference for BF16
        .dif1(), .dif2(), .dif3(), .dif_c(),                   // exp diff in FP8
        .e_fpmax(),                                            // max exp in FP8
        .sum_bf(),
        .cout_bf(),
        .s_fp(),
        .c_fp()
        );
                     
endmodule
