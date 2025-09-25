module cordic_bfloat_linear #(
    parameter int EXP_SIZE      = 8,
    parameter int SIGN_SIZE     = 1, 
    parameter int MANTISSA_SIZE = 7,
    parameter int SIGN_BIT      = 9   // Bit layout:
                                      // [SIGN_BIT-1]  -> Sign
                                      // [EXP_SIZE-1:0] -> Exponent
                                      // [-1:-MANTISSA_SIZE] -> Mantissa
)(
    input  logic clk,
    input  logic EN,
    input  logic [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] x,
    input  logic [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] y,
    output logic done,
    output logic [15:0] out
);

    // Internal registers
    logic signed [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] x_;
    logic signed [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] y_;
    logic signed [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] z_;
    logic signed [7:0] i;

    // Lookup table output
    logic signed [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] Z_UPDATE;

    // Control flags
    logic IS_FIRST4;
    logic IS_FIRST13;

    // Internal connections
    logic [15:0] x_shift_out;
    logic [15:0] y_shift_out;
    logic [15:0] x_out, y_out;
    logic [15:0] x_pos_out, x_neg_out;
    logic [15:0] y_pos_out, y_neg_out;
    logic [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] z_out;
    logic [SIGN_SIZE + EXP_SIZE-1 : -MANTISSA_SIZE] mid_out;

    // Lookup
    atanh_LOOKUP_linear LOOKUP (
        .index(i),
        .value(Z_UPDATE)
    );

    // Z update adder
    fp_adder z1 (
        .mode(~y_[SIGN_BIT-1]),
        .a   (z_),
        .b   (Z_UPDATE),
        .out (z_out)
    );

    // X shift
    rshift r11 (
        .a         (x_),
        .shift_size(i),
        .out       (x_shift_out)
    );

    // Y update adder
    fp_adder y1 (
        .mode(y_[SIGN_BIT-1]),
        .a   (y_),
        .b   (x_shift_out),
        .out (y_out)
    );

    // Pack result (bfloat16 style: sign | exp | mantissa)
    assign out = { z_out[SIGN_BIT-1],
                   z_out[EXP_SIZE-1:0],
                   z_out[-1:-MANTISSA_SIZE] };

    // Done signal
    assign done = (i == 14) && (!EN);

    // Main process
    always_ff @(posedge clk) begin
        if (EN) begin
            // Reset state
            x_          <= x;
            y_          <= y;
            z_          <= '0;
            i           <= -5;
            IS_FIRST4   <= 1'b1;
            IS_FIRST13  <= 1'b1;
        end else begin
            if (i < 14) begin
                i  <= i + 1;
                x_ <= x_;
                y_ <= y_out;
                z_ <= z_out;
            end
        end
    end

endmodule
