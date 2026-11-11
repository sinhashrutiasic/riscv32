`timescale 1ns/1ps

module tb_program_counter;

    logic clk;
    logic rst;

    logic [31:0] pc_next;
    logic [31:0] pc_current;
    logic [31:0] pc_plus4;

    // Instantiate PC
    program_counter dut (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc_current(pc_current),
        .pc_plus4(pc_plus4)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        pc_next = 0;

        #2;
        if (pc_current == 0)
            $display("PASS: Reset");
        else
            $display("FAIL: Reset");

        rst = 0;

        // Test PC = 4
        pc_next = 32'd4;
        @(posedge clk);
        #1;

        if (pc_current == 4 && pc_plus4 == 8)
            $display("PASS: PC increment");

        // Test PC = 8
        pc_next = 32'd8;
        @(posedge clk);
        #1;

        if (pc_current == 8 && pc_plus4 == 12)
            $display("PASS: Second PC update");

        // Test branch-like target
        pc_next = 32'd100;
        @(posedge clk);
        #1;

        if (pc_current == 100 && pc_plus4 == 104)
            $display("PASS: Next address selection");

        $finish;

    end

endmodule
