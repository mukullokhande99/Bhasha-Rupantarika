module cordic_bfloat_hypb (
    input  logic               clk,
    input  logic               EN,
    input  logic signed [8:-7] z,
    output logic        [15:0] out,
    output logic               done
);

    localparam int EXP_SIZE      = 8;
    localparam int SIGN_SIZE     = 1;
    localparam int MANTISSA_SIZE = 7;
    localparam int SIGN_BIT      = 9;  // 8 | EXPONENT | MANTISSA

    // Internal state registers
    logic signed [SIGN_SIZE+EXP_SIZE-1:-MANTISSA_SIZE] x_, y_, z_;
    logic signed [7:0] i;

    logic signed [SIGN_SIZE+EXP_SIZE-1:-MANTISSA_SIZE] Z_UPDATE;
    logic [15:0] x_shift_out, y_shift_out;
    logic [15:0] x_out, y_out, z_out;
    logic [15:0] mid_out;

    // Lookup table
    atanh_lookup_hypb lookup (
        .index(i),
        .value(Z_UPDATE)
    );

    // CORDIC updates
    fp_adder z1 (
        .mode(z_[SIGN_BIT-1]),
        .a(z_),
        .b(Z_UPDATE),
        .out(z_out)
    );

    rshift r11 (
        .a(x_),
        .shift_size(i),
        .out(x_shift_out)
    );

    rshift r12 (
        .a(y_),
        .shift_size(i),
        .out(y_shift_out)
    );

    fp_adder x1 (
        .mode(~z_[SIGN_BIT-1]),
        .a(x_),
        .b(y_shift_out),
        .out(x_out)
    );

    fp_adder y1 (
        .mode(~z_[SIGN_BIT-1]),
        .a(y_),
        .b(x_shift_out),
        .out(y_out)
    );

    fp_adder o (
        .mode(1'b1),
        .a(x_out),
        .b(y_out),
        .out(mid_out)
    );

    // Final output formatting
    assign out = { mid_out[SIGN_BIT-1],
                   (mid_out[EXP_SIZE-1:0] + 8'd11),
                   mid_out[-1:-MANTISSA_SIZE] };

    assign done = (i == 14);

    // Sequential update
    always_ff @(posedge clk) begin
        if (EN) begin
            // Reset-like initialization
            x_ <= 16'h3f80;  // 1.0 in bfloat16
            y_ <= 16'h0000;
            z_ <= z;
            i  <= -5;
        end
        else begin
            if (i < 14) begin
                i  <= i + 1;
                x_ <= x_out;
                y_ <= y_out;
                z_ <= z_out;
            end
        end
    end

endmodule
