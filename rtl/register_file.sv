module register_file (
    input  logic        clk,
    input  logic        rst,

    // Read port 1
    input  logic [4:0]  rs1,
    output logic [31:0] read_data1,

    // Read port 2
    input  logic [4:0]  rs2,
    output logic [31:0] read_data2,

    // Write port
    input  logic        reg_write,
    input  logic [4:0]  rd,
    input  logic [31:0] write_data
);

    // 31 writable registers: x1 to x31
    logic [31:0] registers [1:31];

    integer i;

    // Synchronous register write, asynchronous reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 1; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= write_data;
        end
    end

    // Combinational read port 1
    always_comb begin
        if (rs1 == 5'd0)
            read_data1 = 32'b0;
        else
            read_data1 = registers[rs1];
    end

    // Combinational read port 2
    always_comb begin
        if (rs2 == 5'd0)
            read_data2 = 32'b0;
        else
            read_data2 = registers[rs2];
    end

endmodule
