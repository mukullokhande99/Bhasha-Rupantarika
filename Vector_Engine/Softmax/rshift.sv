module rshift #(
    parameter int EXP_SIZE      = 8,
    parameter int SIGN_BIT      = 9,
    parameter int MANTISSA_SIZE = 7
)(
    input  logic [EXP_SIZE + SIGN_BIT - 1 : -MANTISSA_SIZE] a,
    input  logic signed [7:0] shift_size,
    output logic [15:0] out
);

    logic [15:0] pos_out;
    logic [15:0] neg_out;

    // Compute positive shifted output
    assign pos_out = (a == 16'd0) 
                   ? 16'd0 
                   : ((shift_size < 1) 
                       ? { a[SIGN_BIT-1],
                           (a[EXP_SIZE-1:0] + shift_size - 8'd2),
                           a[-1:-MANTISSA_SIZE]
                         } 
                       : { a[SIGN_BIT-1],
                           (a[EXP_SIZE-1:0] - shift_size),
                           a[-1:-MANTISSA_SIZE]
                         });

    // Instantiate FP adder
    fp_adder z1 (
        .mode (1'b0),
        .a    (a),
        .b    (pos_out),
        .out  (neg_out)
    );

    // Final output selection
    assign out = (a == 16'd0) 
               ? 16'd0 
               : ((shift_size < 1) ? neg_out : pos_out);

endmodule
