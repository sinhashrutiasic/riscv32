module tb_register_file;

    logic clk;
    logic rst;

    logic [4:0] rs1, rs2;
    logic [4:0] rd;

    logic [31:0] read_data1, read_data2;
    logic [31:0] write_data;

    logic reg_write;

    register_file dut (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .reg_write(reg_write),
        .rd(rd),
        .write_data(write_data)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin

        $dumpfile("register_file.vcd");
        $dumpvars(0, tb_register_file);

        // Initialize signals
        rst = 1;
        reg_write = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;

        #12;
        rst = 0;

        // Test 1: Write 10 into x1
        @(negedge clk);
        rd = 1;
        write_data = 32'd10;
        reg_write = 1;

        @(posedge clk);
        #1;
        reg_write = 0;

        rs1 = 1;
        #1;

        if (read_data1 !== 32'd10)
            $fatal(1, "TEST 1 FAILED");

        $display("TEST 1 PASSED: Write and read x1");

        // Test 2: Write 20 into x2
        @(negedge clk);
        rd = 2;
        write_data = 32'd20;
        reg_write = 1;

        @(posedge clk);
        #1;
        reg_write = 0;

        rs1 = 1;
        rs2 = 2;
        #1;

        if (read_data1 !== 32'd10 ||
            read_data2 !== 32'd20)
            $fatal(1, "TEST 2 FAILED");

        $display("TEST 2 PASSED: Two simultaneous reads");

        // Test 3: Attempt to write into x0
        @(negedge clk);
        rd = 0;
        write_data = 32'd100;
        reg_write = 1;

        @(posedge clk);
        #1;
        reg_write = 0;

        rs1 = 0;
        #1;

        if (read_data1 !== 32'd0)
            $fatal(1, "TEST 3 FAILED");

        $display("TEST 3 PASSED: x0 remains zero");

        $display("ALL TESTS PASSED");

        $finish;

    end

endmodule
