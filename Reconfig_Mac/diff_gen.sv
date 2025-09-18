`timescale 1ns / 1ps

module diff_gen(
    input logic [1:0]mode,
    input logic [7:0]e_bf,c_bf,max_bf,          //for BF16
    input logic [3:0]exp1,exp2,exp3,exp4,exp5,exp6,c_fp,max_fp,      //rest of the precision
    output logic [7:0]dif_bfe, dif_bfc,         //for BF16
    output logic [3:0]dif1,dif2,dif3,dif4,dif5,dif6,difc             //rest of the precision
    );
    
    logic [3:0]a1,b1,b2,b3,b4,a5,b5;
    logic [3:0]s1,s2,s3,s4,s5;
    logic [7:0]a2,b6,b7; 
    logic [7:0]s6,s7;
    
    always_comb 
        begin
            if(mode == 2'b00)         //bf16
                begin
                    a1 = max_bf;
                    b6 = e_bf;
                    dif_bfe = s6;
                    
                    b7 = c_bf;
                    dif_bfc = s7;
                end
                
            else if(mode == 2'b01)
                begin
                    a1 = max_fp;
                    
                    b1 = exp1;
                    dif1 = s1;
                    
                    b2 = exp2;
                    dif2 = s2;
                    
                    b3 = exp3;
                    dif3 = s3;
                    
                    b4 = c_fp;
                    difc = s4;
                end
                
            else if(mode == 2'b11)
                begin
                    a1 = max_fp;
                    
                    b1 = exp1;
                    dif1 = s1;
                    
                    b2 = exp2;
                    dif2 = s2;
                    
                    b3 = exp3;
                    dif3 = s3;
                    
                    b4 = exp4;
                    dif4 = s4;
                    
                    b5 = exp5;
                    dif5 = s5;
                    
                    b6 = {4'b0,exp6};
                    dif6 = {4'b0,s6};
                    
                    b7 = {4'b0,c_fp};
                    difc = {4'b0,s7};
                end
                
            else
                begin
                    dif1 = 4'b0;
                    dif2 = 4'b0;
                    dif3 = 4'b0;
                    dif4 = 4'b0;
                    dif5 = 4'b0;
                    dif6 = 4'b0;
                    difc = 4'b0;
                    
                    dif_bfe = 8'b0;
                    dif_bfc = 8'b0;
                end
        end
        
        sub_4bit sub1(
            .A(a1),
            .B(b1),
            .S(s1)
            );
            
        sub_4bit sub2(
            .A(a1),
            .B(b2),
            .S(s2)
            );
            
        sub_4bit sub3(
            .A(a1),
            .B(b3),
            .S(s3)
            );
            
        sub_4bit sub4(
            .A(a1),
            .B(b4),
            .S(s4)
            );
            
        sub_4bit sub5(
            .A(a1),
            .B(b5),
            .S(s5)
            );
            
        sub_8bit sub6(
            .A(a2),
            .B(b6),
            .S(s6)
            );
            
        sub_8bit sub7(
            .A(a2),
            .B(b7),
            .S(s7)
            );
           
endmodule
