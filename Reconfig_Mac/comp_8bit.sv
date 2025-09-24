`timescale 1ns / 1ps

module comp_8bit(
    input logic [7:0] A,
    input logic [7:0] B,
    input logic [3:0]d51,
    input logic [3:0]d52,
    input logic [3:0]d61,
    input logic [3:0]d62,
    input logic [1:0]mode,
    output logic [7:0]Emax
//    output logic [7:0] D1,
//    output logic [7:0] D2
    );
    
//    logic [8:0] S;
//    logic [7:0] p,q;
    
//    always_comb
//        begin
//        if(d11 == 4'b0 && d12 == 4'b0)
//            begin
//                D1 = {4'b0,d21};
//                D2 = {4'b0,d22};
//            end
//        else
//            begin
//                if(d11 == 4'b0)
//                    begin
//                    p = A;
//                    q = B;
//                    end
//                else
//                    begin 
//                    p = B;
//                    q = A;
//                    end
                    
//                D1 = (d11 == 4'b00)? 8'b0: S;
//                D2 = (d11 == 4'b00)? S: 8'b0;                 
                        
//            end
             
//        end


    always_comb
        begin
            if(mode == 2'b00)
            begin
                if(d51 > d52)
                    Emax = B;
                
                else if(d51 < d52)
                    Emax = A;
                
                else
                    begin
                        if(d61 > d62)
                            Emax = B;
                        else if(d61 < d62)
                            Emax = B;
                        else 
                            Emax = 8'b0;
                    end             
            end
        end
        
//add_sub uut(
//    .A(p),
//    .B(q),
//    .addsuben(1'b1),
//    .S(S)
//    );
endmodule
