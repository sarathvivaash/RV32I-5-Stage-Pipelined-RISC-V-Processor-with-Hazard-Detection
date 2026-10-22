module if_id_register_tb;
    logic clk;
    logic reset;
    logic enable;
    logic flush;
    logic [31:0] pc_in;
    logic [31:0] instruction_in;
    logic [31:0] pc_out;
    logic [31:0] instruction_out;

    if_id_register dut (.clk(clk),.reset(reset),.enable(enable),.flush(flush),.pc_in(pc_in),.instruction_in(instruction_in),.pc_out(pc_out),
    .instruction_out(instruction_out));

    always #5 clk = ~clk;
    initial begin
        $dumpfile("waveform/if_id_register.vcd");
        $dumpvars(0, if_id_register_tb);

        clk = 1'b0;
        reset = 1'b1;
        enable = 1'b1;
        flush = 1'b0;
        pc_in = 32'd0;
        instruction_in = 32'd0;
        #10;
        if (pc_out !== 32'd0 || instruction_out !== 32'd0)
            $display("FAIL: Reset");
        else
            $display("PASS: Reset");

        reset = 1'b0; 
        pc_in = 32'd0;
        instruction_in = 32'h00A00093;
        #10;
        if (pc_out !== 32'd0 || instruction_out !== 32'h00A00093)
            $display("FAIL: Test 1");
        else
            $display("PASS: Test 1");

        pc_in = 32'd4;
        instruction_in = 32'h01400113;
        #10;
        if (pc_out !== 32'd4 || instruction_out !== 32'h01400113)
            $display("FAIL: Test 2");
        else
            $display("PASS: Test 2");

        pc_in = 32'd8;
        instruction_in = 32'h002081B3;
        #10;
        if (pc_out !== 32'd8 || instruction_out !== 32'h002081B3)
            $display("FAIL: Test 3");
        else
            $display("PASS: Test 3");

        enable = 1'b0;
        pc_in = 32'd12;
        instruction_in = 32'h40118233;
        #10;
        if (pc_out !== 32'd8 || instruction_out !== 32'h002081B3)
            $display("FAIL: Hold");
        else
            $display("PASS: Hold");

        enable = 1'b1;
        #10;
        if (pc_out !== 32'd12 || instruction_out !== 32'h40118233)
            $display("FAIL: Enable");
        else
            $display("PASS: Enable");

        flush = 1'b1;
        #10;
        if (pc_out !== 32'd0 || instruction_out !== 32'd0)
            $display("FAIL: Flush");
        else
            $display("PASS: Flush");
        $finish;
    end
endmodule
