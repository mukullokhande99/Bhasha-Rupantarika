module prepend #(
    parameter int INPUT_SIZE = 7
)(
    input  logic [INPUT_SIZE-1:0] in,
    output logic [INPUT_SIZE:0]   out
);

    assign out = {1'b1, in};

endmodule
