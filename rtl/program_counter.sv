module program_counter (
    input  logic        clk,
    input  logic        rst,

    input  logic [31:0] pc_next,

    output logic [31:0] pc_current,
    output logic [31:0] pc_plus4
);

    // PC register
    always_ff @(posedge clk or posedge rst) begin

        if (rst)
            pc_current <= 32'h00000000;

        else
            pc_current <= pc_next;

    end

    // Calculate next sequential address
    always_comb begin
        pc_plus4 = pc_current + 32'd4;
    end

endmodule
