module atanh_lookup_hypb (
    input  logic signed [7:0] index,
    output logic signed [8:-7] value
);

    
    always_comb begin
        unique case (index)
            -5  : value = 16'h4031;  // atanh(1-2^(-7))
            -4  : value = 16'h401b;  // atanh(1-2^(-6))
            -3  : value = 16'h4004;  // atanh(1-2^(-5))
            -2  : value = 16'h3fdb;  // atanh(1-2^(-4))
            -1  : value = 16'h3fad;  // atanh(1-2^(-3))
             0  : value = 16'h3f79;  // atanh(1-2^(-2))
             1  : value = 16'h3f0c;  // atanh(2^(-1))
             2  : value = 16'h3e82;  // atanh(2^(-2))
             3  : value = 16'h3e00;  // atanh(2^(-3))
             4  : value = 16'h3d80;  // atanh(2^(-4))
             5  : value = 16'h3d00;  // atanh(2^(-5))
             6  : value = 16'h3c80;  // atanh(2^(-6))
             7  : value = 16'h3c00;  // atanh(2^(-7))
             8  : value = 16'h3b80;  // atanh(2^(-8))
             9  : value = 16'h3b00;  // atanh(2^(-9))
            10  : value = 16'h3a80;  // atanh(2^(-10))
            11  : value = 16'h39ff;  // atanh(2^(-11))
            12  : value = 16'h3980;  // atanh(2^(-12))
            13  : value = 16'h3900;  // atanh(2^(-13))
            default: value = 16'h0000;
        endcase
    end

endmodule
