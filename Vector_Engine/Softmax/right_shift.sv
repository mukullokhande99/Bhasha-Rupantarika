module right_shift #(
    parameter int INPUT_SIZE = 8,
    parameter int SHIFT_SIZE = 1
)(
    input  logic [INPUT_SIZE-1:0] in,            // Input value
    input  logic [SHIFT_SIZE-1:0] shift_amount,  // Shift amount
    input  logic                  condition,     // 1 = right shift, 0 = left shift
    output logic [INPUT_SIZE-1:0] out            // Shifted output
);

    always_comb begin
        if (condition)
            out = in >>> shift_amount;  // Arithmetic right shift
        else
            out = in << shift_amount;   // Left shift
    end

endmodule
