module fp_adder #(
    parameter int EXP_SIZE      = 8,
    parameter int SIGN_SIZE     = 1,
    parameter int MANTISSA_SIZE = 7,
    parameter int SIGN_BIT      = 9
)(
    input  logic [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] a,
    input  logic [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] b,
    input  logic mode,
    output logic [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] out
);

    // Internal signals
    logic a_sign, b_sign, b_sign1, borrow, carry;
    logic [MANTISSA_SIZE-1:0] a_mantissa, b_mantissa, m1_out, m2_out, out_mantissa;
    logic [EXP_SIZE-1:0]      a_exp, b_exp, sub_exp_out, m3_out, out_exp;
    logic [MANTISSA_SIZE:0]   p1_out, r1_out, p2_out, r2_out, a1_out;
    logic outSignBit, condition;

    // Decompose inputs
    assign {a_sign, a_exp, a_mantissa}   = a;
    assign {b_sign1, b_exp, b_mantissa}  = b;

    // Adjust sign depending on mode
    assign b_sign = mode ? b_sign1 : ~b_sign1;

    assign condition = (a_sign == b_sign);

    // Subtract exponents
    sub #(.INPUT_SIZE(EXP_SIZE)) s1 (
        .a(a_exp),
        .b(b_exp),
        .out(sub_exp_out),
        .borrow(borrow)
    );

    // Choose mantissas depending on borrow
    mux_2_1 #(.INPUT_SIZE(MANTISSA_SIZE)) m1 (
        .in0(b_mantissa),
        .in1(a_mantissa),
        .sel(borrow),
        .out(m1_out)
    );

    mux_2_1 #(.INPUT_SIZE(MANTISSA_SIZE)) m2 (
        .in0(a_mantissa),
        .in1(b_mantissa),
        .sel(borrow),
        .out(m2_out)
    );

    prepend #(.INPUT_SIZE(MANTISSA_SIZE)) p1 (
        .in(m1_out),
        .out(p1_out)
    );

    right_shift #(
        .INPUT_SIZE(MANTISSA_SIZE+1),
        .SHIFT_SIZE(EXP_SIZE)
    ) r1 (
        .in(p1_out),
        .shift(sub_exp_out),
        .out(r1_out),
        .enable(1'b1)
    );

    prepend #(.INPUT_SIZE(MANTISSA_SIZE)) p2 (
        .in(m2_out),
        .out(p2_out)
    );

    // Subtract mantissas
    logic [MANTISSA_SIZE:0] sub_man_out;
    logic man_borrow;

    sub #(.INPUT_SIZE(MANTISSA_SIZE+1)) s2 (
        .a(r1_out),
        .b(p2_out),
        .out(sub_man_out),
        .borrow(man_borrow)
    );

    logic [MANTISSA_SIZE:0] man3_out, man4_out;

    mux_2_1 #(.INPUT_SIZE(MANTISSA_SIZE+1)) m5 (
        .in0(r1_out),
        .in1(p2_out),
        .sel(man_borrow),
        .out(man3_out)
    );

    mux_2_1 #(.INPUT_SIZE(MANTISSA_SIZE+1)) m4 (
        .in0(p2_out),
        .in1(r1_out),
        .sel(man_borrow),
        .out(man4_out)
    );

    mux_2_1 #(.INPUT_SIZE(EXP_SIZE)) m3 (
        .in0(a_exp),
        .in1(b_exp),
        .sel(borrow),
        .out(m3_out)
    );

    adder_sub_8_bit a1 (
        .a(man3_out),
        .b(man4_out),
        .out(a1_out),
        .condition(condition),
        .exp(m3_out),
        .exp_out(out_exp)
    );

    // Final mantissa
    assign out_mantissa = a1_out[MANTISSA_SIZE-1:0];

    // Output sign bit selection
    assign outSignBit = ((a_exp > b_exp) ||
                        ((a_exp == b_exp) && (a_mantissa >= b_mantissa)))
                        ? a_sign : b_sign;

    // Final output
    assign out = {outSignBit, out_exp, out_mantissa};

endmodule
