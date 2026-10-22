module ex_mem_register_tb;
    logic clk;
    logic reset;
    logic [31:0] alu_result_in;
    logic [31:0] write_data_in;
    logic [4:0]  rd_in;
    logic reg_write_in;
    logic mem_read_in;
    logic mem_write_in;
    logic [31:0] alu_result_out;
    logic [31:0] write_data_out;
    logic [4:0]  rd_out;
    logic reg_write_out;
    logic mem_read_out;
    logic mem_write_out;

    ex_mem_register dut (.clk(clk),.reset(reset),.alu_result_in(alu_result_in),.write_data_in(write_data_in),.rd_in(rd_in),
    .reg_write_in(reg_write_in),.mem_read_in(mem_read_in),.mem_write_in(mem_write_in),.alu_result_out(alu_result_out),
    .write_data_out(write_data_out),.rd_out(rd_out),.reg_write_out(reg_write_out),.mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out));

    always #5 clk = ~clk;
    initial begin
        $dumpfile("waveform/ex_mem_register.vcd");
        $dumpvars(0, ex_mem_register_tb);

        clk = 0;
        reset = 1;
        alu_result_in = 0;
        write_data_in = 0;
        rd_in = 0;
        reg_write_in = 0;
        mem_read_in = 0;
        mem_write_in = 0;
        // Test 1: Reset
        #10;
        if (alu_result_out !== 32'd0 || write_data_out !== 32'd0 || rd_out !== 5'd0 || reg_write_out !== 1'b0 ||
        mem_read_out !== 1'b0 || mem_write_out !== 1'b0)
            $display("FAIL: Reset");
        else
            $display("PASS: Reset");

        reset = 0;
        // Test 2: Arithmetic instruction - ADD x3, x1, x2
        alu_result_in = 32'd30;
        write_data_in = 32'd0;
        rd_in = 5'd3;
        reg_write_in = 1;
        mem_read_in = 0;
        mem_write_in = 0;
        #10;
        if (alu_result_out !== 32'd30 || rd_out !== 5'd3 || reg_write_out !== 1'b1 || mem_read_out !== 1'b0 ||
        mem_write_out !== 1'b0)
            $display("FAIL: ADD");
        else
            $display("PASS: ADD");

        // Test 3: Load instruction - LW x7, 0(x0)
        alu_result_in = 32'd0;
        write_data_in = 32'd0;
        rd_in = 5'd7;
        reg_write_in = 1;
        mem_read_in = 1;
        mem_write_in = 0;
        #10;
        if (alu_result_out !== 32'd0 || rd_out !== 5'd7 || reg_write_out !== 1'b1 || mem_read_out !== 1'b1 ||
        mem_write_out !== 1'b0)
            $display("FAIL: LW");
        else
            $display("PASS: LW");

        // Test 4: Store instruction - SW x3, 0(x0)
        alu_result_in = 32'd0;
        write_data_in = 32'd30;
        rd_in = 5'd0;
        reg_write_in = 0;
        mem_read_in = 0;
        mem_write_in = 1;
        #10;
        if (alu_result_out !== 32'd0 || write_data_out !== 32'd30 || rd_out !== 5'd0 || reg_write_out !== 1'b0 ||
        mem_read_out !== 1'b0 || mem_write_out !== 1'b1)
            $display("FAIL: SW");
        else
            $display("PASS: SW");
        $finish;
    end
endmodule
