`timescale 1ns / 1ps

module align_add(
    input logic [1:0]mode,
    input logic [7:0] in1,in2,in3,in4,in5,in6,        //ops of bfb 1 2 3 4,  partial products 4 used in BF16 and 3 in FP8, 6 in int4
    input logic [15:0]c_acc_bf,                       //addent value for BF16, mantissa
    input logic [7:0] c_acc_fp,
    input logic [7:0]e_bfmax,                         //max exponent for product and accum value for BF16 
    input logic [7:0] bfe_dif,bfc_dif,                //exp difference for BF16
    input logic [3:0] dif1, dif2, dif3,dif_c,         //exp diff in FP8 
    input logic [3:0] e_fpmax,                        // max exp values in FP8
    output logic [15:0] sum_bf,
    output logic cout_bf,
    output logic [7:0] s_fp,
    output logic c_fp
    );
    
    logic [15:0]p1,p2,p3,p4,p5;
    logic s1,s2,s3,s4;
    logic c1,c2,c3,c4;
    
    logic [7:0] q1,q2,q3,q4,q5,q6,q7;
    logic [7:0] r1,r2,r3,r4,r5,r6;
    logic t1,t2,t3,t4,t5,t6;
    
    always_comb
        begin
            if(mode == 2'b00)
                begin
                    p1 = {in1,in4};
                    p2 = {4'b0,in2,4'b0};
                    p3 = {4'b0,in3,4'b0};
                    p4 = {8'b0,in4};
                    p5 = c_acc_bf;
                end
                
            if(mode == 2'b01)
                begin
                    q1 = in1;
                    q2 = in2;
                    q3 = in3;
                    q4 = c_acc_fp;
                    
                    s_fp = r3;
                    c_fp = t3;
                end
                
            if(mode == 2'b11)
                begin
                    q1 = in1;
                    q2 = in2;
                    q3 = in3;
                    q4 = in4;
                    q5 = in5;
                    q6 = in6;
                    q7 = c_acc_fp;
                    
                    s_fp = r6;
                    c_fp = t6;
                end
                
                
        end
        
    csla_16bit b1(
        .A(p1),
        .B(p2),
        .addsub(1'b0),
        .Cin(1'b0),
        .sum(s1),
        .cout(c1)
        );
        
    csla_16bit b2(
        .A(s1),
        .B(p4),
        .addsub(1'b0),
        .Cin(c1),
        .sum(s2),
        .cout(c2)
        );
        
     csla_16bit b3(
        .A(s2),
        .B(p3),
        .addsub(1'b0),
        .Cin(1'b0),
        .sum(s3),
        .cout(c3)
        );
        
     csla_16bit b4(
        .A(p3),
        .B(p4),
        .addsub(1'b0),
        .Cin(1'b0),
        .sum(s4),
        .cout(c4)
        );
        
     csla_16bit b5(
        .A(s4),
        .B(p5),
        .addsub(1'b0),
        .Cin(1'b0),
        .sum(sum_bf),            //final output and carry of bf16
        .cout(cout_bf)
        );
        
        
        
        asub z1(
            .A(p1),
            .B(p2),
            .addsub(1'b0),         //need to map wrt sign
            .Cin(1'b0),
            .sum(r1),
            .Cout(t1)
            );
            
        asub z2(
            .A(r1),
            .B(p3),
            .addsub(1'b0),
            .Cin(t1),
            .sum(r2),
            .Cout(t2)
            );
            
        asub z3(
            .A(r2),
            .B(p4),
            .addsub(1'b0),
            .Cin(t2),
            .sum(r3),
            .Cout(t3)
            );
            
       asub z4(
            .A(r3),
            .B(p5),
            .addsub(1'b0),
            .Cin(t3),
            .sum(r4),
            .Cout(t4)
            );
            
        asub z5(
            .A(r4),
            .B(p6),
            .addsub(1'b0),
            .Cin(t4),
            .sum(r5),
            .Cout(t5)
            );    
         
        asub z6(
            .A(r5),
            .B(p7),
            .addsub(1'b0),
            .Cin(t5),
            .sum(r6),
            .Cout(t6)
            );
        
endmodule
