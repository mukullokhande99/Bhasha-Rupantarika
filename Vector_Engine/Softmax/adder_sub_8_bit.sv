module adder_sub_8_bit (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic       condition,   // 1 = addition, 0 = subtraction
    input  logic [7:0] exp,
    output logic [7:0] out,
    output logic [7:0] exp_out
);

    logic carry;
    logic [8:0] temp;   // To hold result with carry/borrow

    always_comb begin
        out     = 8'd0;
        exp_out = exp;
        carry   = 1'b0;
        temp    = 9'd0;

        if (condition) begin
            // Perform addition
            temp   = a + b;
            carry  = temp[8];
            out    = temp[7:0];

            // Normalize: shift right if carry generated
            out     = out >> carry;
            exp_out = exp_out + carry;
        end else begin
            // Perform subtraction (absolute difference)
            if (a > b) temp = a - b;
            else       temp = b - a;

            out = temp[7:0];

            // Normalize: left shift until MSB = 1
            for (int i = 0; i < 8 && out[7] != 1'b1; i++) begin
                out     = out << 1;
                exp_out = exp_out - 1;
            end
        end
    end

endmodule
