module mux_2_1 #(
    parameter int INPUT_SIZE = 8
)(
    input  logic [INPUT_SIZE-1:0] in0,   // First input
    input  logic [INPUT_SIZE-1:0] in1,   // Second input
    input  logic                  sel,   // Select line
    output logic [INPUT_SIZE-1:0] out    // Output
);

    // Combinational assignment
    assign out = sel ? in1 : in0;

endmodule
