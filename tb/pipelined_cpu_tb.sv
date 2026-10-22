module pipelined_cpu_tb;
    logic clk;
    logic reset;
    integer i;
    integer stall_count;
    integer branch_count;
    integer jal_count;
    logic [31:0] held_pc;
    logic [31:0] held_instruction;

    pipelined_cpu dut (.clk(clk),.reset(reset));

    always #5 clk = ~clk;

    // Monitor actual pipeline control behavior
    always @(negedge clk) begin
        if (!reset) begin
            if (dut.stall === 1'b1) begin
                stall_count = stall_count + 1;
                held_pc = dut.pc_current;
                held_instruction = dut.instruction_id;
                #1;
                if (dut.pc_current !== held_pc || dut.instruction_id !== held_instruction)
                    $display("FAIL: PC/IF-ID Hold During Stall");
                else
                    $display("PASS: PC/IF-ID Hold During Stall");
            end

            if (dut.branch_taken === 1'b1) begin
                branch_count = branch_count + 1;
                if (dut.pc_next !== dut.branch_target)
                    $display("FAIL: Branch Target Selection");
                else
                    $display("PASS: Branch Target Selection");
            end

            if (dut.jump_ex === 1'b1) begin
                jal_count = jal_count + 1;
                if (dut.pc_next !== dut.jump_target)
                    $display("FAIL: JAL Target Selection");
                else
                    $display("PASS: JAL Target Selection");
            end
        end
    end

    initial begin
        $dumpfile("waveform/pipelined_cpu.vcd");
        $dumpvars(0, pipelined_cpu_tb);

        clk = 1'b0;
        reset = 1'b1;
        stall_count = 0;
        branch_count = 0;
        jal_count = 0;
        held_pc = 32'd0;
        held_instruction = 32'd0;

        #1;
        for (i = 0; i < 256; i = i + 1)
            dut.instruction_memory_unit.instruction_memory[i] = 32'h00000013;

        dut.register_file_unit.registers[13] = 32'd0;
        dut.register_file_unit.registers[16] = 32'd0;
        // Test Program
        dut.instruction_memory_unit.instruction_memory[0]  = 32'h00A00093; // ADDI x1, x0, 10
        dut.instruction_memory_unit.instruction_memory[1]  = 32'h01400113; // ADDI x2, x0, 20
        dut.instruction_memory_unit.instruction_memory[2]  = 32'h002081B3; // ADD  x3, x1, x2
        dut.instruction_memory_unit.instruction_memory[3]  = 32'h40118233; // SUB  x4, x3, x1
        dut.instruction_memory_unit.instruction_memory[4]  = 32'h0021F2B3; // AND  x5, x3, x2
        dut.instruction_memory_unit.instruction_memory[5]  = 32'h0020E333; // OR   x6, x1, x2
        dut.instruction_memory_unit.instruction_memory[6]  = 32'h00302023; // SW   x3, 0(x0)
        dut.instruction_memory_unit.instruction_memory[7]  = 32'h00002383; // LW   x7, 0(x0)
        dut.instruction_memory_unit.instruction_memory[8]  = 32'h00002403; // LW   x8, 0(x0)
        dut.instruction_memory_unit.instruction_memory[9]  = 32'h00540493; // ADDI x9, x8, 5
        dut.instruction_memory_unit.instruction_memory[10] = 32'h00700513; // ADDI x10, x0, 7
        dut.instruction_memory_unit.instruction_memory[11] = 32'h00350593; // ADDI x11, x10, 3
        dut.instruction_memory_unit.instruction_memory[12] = 32'h00A58633; // ADD  x12, x11, x10
        dut.instruction_memory_unit.instruction_memory[13] = 32'h00108463; // BEQ  x1, x1, +8
        dut.instruction_memory_unit.instruction_memory[14] = 32'h06300693; // Wrong path: ADDI x13, x0, 99
        dut.instruction_memory_unit.instruction_memory[15] = 32'h01600713; // ADDI x14, x0, 22
        dut.instruction_memory_unit.instruction_memory[16] = 32'h008007EF; // JAL  x15, +8
        dut.instruction_memory_unit.instruction_memory[17] = 32'h06300813; // Wrong path: ADDI x16, x0, 99
        dut.instruction_memory_unit.instruction_memory[18] = 32'h01700893; // ADDI x17, x0, 23
        dut.data_memory_unit.memory[0] = 32'd0;

        #19;
        reset = 1'b0;
        #500;

        // Test 1: ADDI x1, x0, 10
        if (dut.register_file_unit.registers[1] !== 32'd10)
            $display("FAIL: ADDI x1");
        else
            $display("PASS: ADDI x1");

        // Test 2: ADDI x2, x0, 20
        if (dut.register_file_unit.registers[2] !== 32'd20)
            $display("FAIL: ADDI x2");
        else
            $display("PASS: ADDI x2");

        // Test 3: ADD x3, x1, x2
        if (dut.register_file_unit.registers[3] !== 32'd30)
            $display("FAIL: ADD x3");
        else
            $display("PASS: ADD x3");

        // Test 4: SUB x4, x3, x1
        if (dut.register_file_unit.registers[4] !== 32'd20)
            $display("FAIL: SUB x4");
        else
            $display("PASS: SUB x4");

        // Test 5: AND x5, x3, x2
        if (dut.register_file_unit.registers[5] !== 32'd20)
            $display("FAIL: AND x5");
        else
            $display("PASS: AND x5");

        // Test 6: OR x6, x1, x2
        if (dut.register_file_unit.registers[6] !== 32'd30)
            $display("FAIL: OR x6");
        else
            $display("PASS: OR x6");

        // Test 7: SW x3, 0(x0)
        if (dut.data_memory_unit.memory[0] !== 32'd30)
            $display("FAIL: SW");
        else
            $display("PASS: SW");

        // Test 8: LW x7, 0(x0)
        if (dut.register_file_unit.registers[7] !== 32'd30)
            $display("FAIL: LW x7");
        else
            $display("PASS: LW x7");

        // Test 9: Load-use dependency: LW x8 followed by ADDI x9
        if (dut.register_file_unit.registers[8] !== 32'd30 ||
            dut.register_file_unit.registers[9] !== 32'd35)
            $display("FAIL: Load-use Hazard");
        else
            $display("PASS: Load-use Hazard");

        if (stall_count > 0)
            $display("PASS: Load-use Stall Observed");
        else
            $display("FAIL: Load-use Stall Not Observed");

        // Test 10: Forwarding from recent arithmetic results
        if (dut.register_file_unit.registers[10] !== 32'd7 ||
            dut.register_file_unit.registers[11] !== 32'd10 ||
            dut.register_file_unit.registers[12] !== 32'd17)
            $display("FAIL: Forwarding");
        else
            $display("PASS: Forwarding");

        // Test 11: Taken BEQ skips wrong-path instruction
        if (dut.register_file_unit.registers[13] !== 32'd0 ||
            dut.register_file_unit.registers[14] !== 32'd22)
            $display("FAIL: BEQ and Flush");
        else
            $display("PASS: BEQ and Flush");

        if (branch_count > 0)
            $display("PASS: Branch Redirect Observed");
        else
            $display("FAIL: Branch Redirect Not Observed");

        // Test 12: JAL link address and wrong-path flushing
        if (dut.register_file_unit.registers[15] !== 32'd68 ||
            dut.register_file_unit.registers[16] !== 32'd0 ||
            dut.register_file_unit.registers[17] !== 32'd23)
            $display("FAIL: JAL and Flush");
        else
            $display("PASS: JAL and Flush");

        if (jal_count > 0)
            $display("PASS: JAL Redirect Observed");
        else
            $display("FAIL: JAL Redirect Not Observed");

        // Test 13: x0 protection
        if (dut.register_file_unit.registers[0] !== 32'd0)
            $display("FAIL: x0 Protection");
        else
            $display("PASS: x0 Protection");
        $finish;
    end
endmodule
