module sub #(
    parameter int INPUT_SIZE = 7
)(
    input  logic [INPUT_SIZE-1:0] a,
    input  logic [INPUT_SIZE-1:0] b,
    output logic [INPUT_SIZE-1:0] out,
    output logic                  borrow
);

    logic signed [INPUT_SIZE:0] diff;  // one extra bit for signed math

    assign diff   = a - b;
    assign borrow = diff[INPUT_SIZE];   // MSB indicates borrow
    assign out    = borrow ? -diff[INPUT_SIZE-1:0] : diff[INPUT_SIZE-1:0];

endmodule
