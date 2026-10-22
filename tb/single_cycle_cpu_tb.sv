module single_cycle_cpu_tb;
    logic clk;
    logic reset;

    single_cycle_cpu dut (.clk(clk),.reset(reset));
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform/single_cycle_cpu.vcd");
        $dumpvars(0, single_cycle_cpu_tb);

        clk   = 1'b0;
        reset = 1'b1;
        #10;
        reset = 1'b0;
        #100;
        // Check register results
        if (dut.register_file_unit.registers[1] !== 32'd10)
            $display("FAIL: x1 = %d, expected 10", dut.register_file_unit.registers[1]);
        else
            $display("PASS: x1 = 10");

        if (dut.register_file_unit.registers[2] !== 32'd20)
            $display("FAIL: x2 = %d, expected 20", dut.register_file_unit.registers[2]);
        else
            $display("PASS: x2 = 20");

        if (dut.register_file_unit.registers[3] !== 32'd30)
            $display("FAIL: x3 = %d, expected 30", dut.register_file_unit.registers[3]);
        else
            $display("PASS: x3 = 30");

        if (dut.register_file_unit.registers[4] !== 32'd20)
            $display("FAIL: x4 = %d, expected 20", dut.register_file_unit.registers[4]);
        else
            $display("PASS: x4 = 20");

        if (dut.register_file_unit.registers[5] !== 32'd20)
            $display("FAIL: x5 = %d, expected 20", dut.register_file_unit.registers[5]);
        else
            $display("PASS: x5 = 20");

        if (dut.register_file_unit.registers[6] !== 32'd30)
            $display("FAIL: x6 = %d, expected 30", dut.register_file_unit.registers[6]);
        else
            $display("PASS: x6 = 30");

        // Check store
        if (dut.data_memory_unit.memory[0] !== 32'd30)
            $display("FAIL: memory[0] = %d, expected 30",
                     dut.data_memory_unit.memory[0]);
        else
            $display("PASS: memory[0] = 30");

        // Check load
        if (dut.register_file_unit.registers[7] !== 32'd30)
            $display("FAIL: x7 = %d, expected 30", dut.register_file_unit.registers[7]);
        else
            $display("PASS: x7 = 30");
        $finish;
    end
endmodule