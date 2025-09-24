`timescale 1ns / 1ps

module decoder(
    input logic [23:0] A,B,
    input logic [15:0]C,
    input logic [1:0]mode,
    output logic [3:0] b11,b12,e1,
    output logic [3:0] b21,b22,e2,
    output logic [3:0] b31,b32,e3,
    output logic [3:0] b41,b42,e4,
    output logic [3:0] b51,b52,e5,
    output logic [3:0] b61,b62,e6,
    output logic s1,s2,s3,s4,s5,s6,
    output logic [7:0]man_c //, exp_c            //mantissa and exponent of C ka alag output, diff gen mai par konsa input jaega?
    );
    
    logic [7:0]exp0;
    logic [3:0]exp1, exp2, exp3, exp4, exp5, exp6;    //max exponent ke corresponding sign bhi chahiye....
    
    
    always_comb
        begin
            if(mode == 2'b00)
                begin
                    b11 = {1'b1,A[6:4]};
                    b12 = {1'b1,B[6:4]};
                    e1 = 1'b0;
                    
                    b21 = A[3:0];
                    b22 = {1'b1,B[6:4]};
                    e2 = 1'b0;
                    
                    b31 = {1'b1,A[6:4]};
                    b32 = B[3:0];
                    e3 = 1'b0;
                    
                    b41 = A[3:0];
                    b42 = B[3:0];
                    e4 = 1'b0;

                    assign exp0 = A[14:7] + B[14:7] - 8'd127;
                    s1 = A[15] ^ B[15];   //final sign , no accumulation would be done later
                                        
                    b51 = exp0[7:4];
                    b52 = C[14:11];
                    e5 = 1'b1;
                    
                    b61 = exp0[3:0];
                    b62 = C[10:7];
                    e6 = 1'b1;
                    
                    man_c = {1'b1,C[6:0]};
                    
                end
                
            else if (mode == 2'b01)
                begin
                    b11 = {1'b1,A[18:16]};
                    b12 = {1'b1,B[18:16]};
                    e1 = 1'b0;
                    
                    b21 = {1'b1,A[10:8]};
                    b22 = {1'b1,B[10:8]};
                    e2 = 1'b0;
                    
                    b31 = {1'b1,A[2:0]};
                    b32 = {1'b1,B[2:0]};
                    e3 = 1'b0;
                    
                    assign exp1 = A[22:19] + B[22:19] - 4'd7;    //need to instantiate 4 bit adder with overflow control and inputs depending on the mode control signal
                    assign exp2 = A[14:11] + B[14:11] - 4'd7;
                    assign exp3 = A[6:3] + B[6:3] - 4'd7;
                    
                    s1 = A[23] ^ B[23];           //acc according to sign of multiplication
                    s2 = A[15] ^ B[15];
                    s3 = A[7] ^ B[7];
                    
                    b41 = exp1;
                    b42 = exp2;
                    e4 = 1'b1;
                    
                    b51 = exp3;
                    b52 = C[6:3];
                    e5 = 1'b1;
                    
                    e6 = 1'b1;
                    
                    //b61 and b62 b4 b5 ke output se jaenge in top module directly
                    man_c = {1'b1,C[2:0],4'b0};          //galat hai.... change karna padega, accumulated value ko normalize nai kar sakta
                           
                end
            
            else if (mode == 2'b10)
                begin
                    assign exp1 = {1'b0,A[22:20]} + {1'b0,B[22:20]} - 4'd3;
                    assign exp2 = {1'b0,A[18:16]} + {1'b0,B[18:16]} - 4'd3;
                    assign exp3 = {1'b0,A[14:12]} + {1'b0,B[14:12]} - 4'd3;
                    assign exp4 = {1'b0,A[10:8]} + {1'b0,B[10:8]} - 4'd3;
                    assign exp5 = {1'b0,A[6:4]} + {1'b0,B[6:4]} - 4'd3;
                    assign exp6 = {1'b0,A[2:0]} + {1'b0,B[2:0]} - 4'd3;
                    
                    s1 = A[23] ^ B[23];
                    s2 = A[19] ^ B[19]; 
                    s3 = A[15] ^ B[15];
                    s4 = A[11] ^ B[11];
                    s5 = A[7] ^ B[7];
                    s6 = A[3] ^ B[3];
                    
                    b11 = exp1;
                    b12 = exp2;
                    e1 = 1'b1;
                    
                    b21 = exp3;
                    b22 = exp4;
                    e2 = 1'b1;
                    
                    b31 = exp5;
                    b32 = exp6;
                    e3 = 1'b1;
                    
                    e4 = 1'b1;
                    e5 = 1'b1;
                    e6 = 1'b1;
                    //baki ke inke outputs in top module                   
                end
                
            else
                begin
                    b11 = A[23:20];
                    b12 = B[23:20];
                    e1 = 1'b0;
                    
                    b21 = A[19:16];
                    b22 = B[19:16];
                    e2 = 1'b0;
                    
                    b31 = A[15:12];
                    b32 = B[15:12];
                    e3 = 1'b0;
                    
                    b41 = A[11:8];
                    b42 = B[11:8];
                    e4 = 1'b0;
                    
                    b51 = A[7:4];
                    b52 = B[7:4];
                    e5 = 1'b0;
                    
                    b61 = A[3:0];
                    b62 = B[3:0];
                    e6 = 1'b0;
                end
           
        end
endmodule
