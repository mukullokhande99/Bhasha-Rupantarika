module atanh_LOOKUP_linear (
    input  logic signed [7:0] index,
    output logic signed [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] value
);
    parameter int EXP_SIZE      = 8;
    parameter int SIGN_SIZE     = 1;
    parameter int MANTISSA_SIZE = 7;

    always_comb begin
        unique case (index)
            -5:  value = 16'h3f7e;  // atanh(1-2^(-7)) ≈ 0x02_c5481e
            -4:  value = 16'h3f7c;  // atanh(1-2^(-6)) ≈ 0x02_6c0b28
            -3:  value = 16'h3f78;  // atanh(1-2^(-5))
            -2:  value = 16'h3f70;  // atanh(1-2^(-4))
            -1:  value = 16'h3f60;  // atanh(1-2^(-3))
             0:  value = 16'h3f40;  // atanh(1-2^(-2))
             1:  value = 16'h3f00;  // atanh(2^(-1))
             2:  value = 16'h3e80;  // atanh(2^(-2))
             3:  value = 16'h3e00;  // atanh(2^(-3))
             4:  value = 16'h3d80;  // atanh(2^(-4))
             5:  value = 16'h3d00;  // atanh(2^(-5))
             6:  value = 16'h3c80;  // atanh(2^(-6))
             7:  value = 16'h3c00;  // atanh(2^(-7))
             8:  value = 16'h3b80;  // atanh(2^(-8))
             9:  value = 16'h3b00;  // atanh(2^(-9))
            10:  value = 16'h3a80;  // atanh(2^(-10))
            11:  value = 16'h3a00;  // atanh(2^(-11))
            12:  value = 16'h3980;  // atanh(2^(-12))
            13:  value = 16'h3900;  // atanh(2^(-13))
            default: value = '0;   // default = zero
        endcase
    end

endmodule
