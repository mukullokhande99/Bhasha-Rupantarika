module softmax_parallel_bf_asic (
    input  logic signed [8:-7] e1, e2, e3, e4, e5, e6, e7, e8, e9, e10,
    input  logic               clk,
    input  logic               EN,
    output logic signed [8:-7] s1, s2, s3, s4, s5, s6, s7, s8, s9, s10
);

    localparam int EXP_SIZE      = 8;
    localparam int SIGN_SIZE     = 1;
    localparam int MANTISSA_SIZE = 7;
    localparam int SIGN_BIT      = 9;

    logic [15:0] exp   [0:9];
    logic        done  [0:9];

    logic signed [8:-7] e_in [0:9];
    assign e_in[0] = e1;
    assign e_in[1] = e2;
    assign e_in[2] = e3;
    assign e_in[3] = e4;
    assign e_in[4] = e5;
    assign e_in[5] = e6;
    assign e_in[6] = e7;
    assign e_in[7] = e8;
    assign e_in[8] = e9;
    assign e_in[9] = e10;

    genvar gi;
    generate
        for (gi = 0; gi < 10; gi++) begin : EXP_GEN
            cordic_bfloat_hypb u_exp (
                .clk(clk),
                .EN(EN),
                .z(e_in[gi]),
                .out(exp[gi]),
                .done(done[gi])
            );
        end
    endgenerate

    logic [15:0] exp_mem [0:9];

    always_ff @(posedge clk) begin
        for (int i = 0; i < 10; i++) begin
            exp_mem[i] <= exp[i];
        end
    end

    logic [15:0] buffer, buf_fb;
    logic [15:0] add_in, add_fb, add_out;
    logic [3:0]  count;
    logic        enable;
    logic        lin_enable;

    always_ff @(posedge clk) begin
        if (EN) begin
            buffer <= 16'd0;
            buf_fb <= 16'd0;
            count  <= 4'd0;
        end
        else begin
            if (done[0] && (count < 4'd10)) begin
                buffer <= exp_mem[count];
                buf_fb <= add_out;
                count  <= count + 4'd1;
            end
        end
    end

    assign enable = (count == 4'd10) ? 1'b0 : 1'b1;

    always_ff @(posedge clk) lin_enable <= enable;

    assign add_in = buffer;
    assign add_fb = buf_fb;

    fp_adder exp_add (
        .mode(1'b1),
        .a(add_in),
        .b(add_fb),
        .out(add_out)
    );

    logic lin_done [0:9];
    logic [15:0] s_out [0:9];

    generate
        for (gi = 0; gi < 10; gi++) begin : LIN_GEN
            cordic_bfloat_linear u_lin (
                .clk(clk),
                .EN(lin_enable),
                .x(add_out),
                .y(exp_mem[gi]),
                .done(lin_done[gi]),
                .out(s_out[gi])
            );
        end
    endgenerate

    assign s1  = s_out[0];
    assign s2  = s_out[1];
    assign s3  = s_out[2];
    assign s4  = s_out[3];
    assign s5  = s_out[4];
    assign s6  = s_out[5];
    assign s7  = s_out[6];
    assign s8  = s_out[7];
    assign s9  = s_out[8];
    assign s10 = s_out[9];

endmodule
