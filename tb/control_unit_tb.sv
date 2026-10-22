module control_unit_tb;
    logic [6:0] opcode;
    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic alu_src;
    logic branch;
    logic jump;

    control_unit dut (.opcode(opcode),.reg_write(reg_write),.mem_read(mem_read),.mem_write(mem_write),.alu_src(alu_src),
    .branch(branch),.jump(jump));

    initial begin
        $dumpfile("waveform/control_unit.vcd");
        $dumpvars(0, control_unit_tb);

        // R-type
        opcode = 7'b0110011;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b100000)
            $display("FAIL: R-type");
        else
            $display("PASS: R-type");

        // ADDI
        opcode = 7'b0010011;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b100100)
            $display("FAIL: ADDI");
        else
            $display("PASS: ADDI");

        // LW
        opcode = 7'b0000011;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b110100)
            $display("FAIL: LW");
        else
            $display("PASS: LW");

        // SW
        opcode = 7'b0100011;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b001100)
            $display("FAIL: SW");
        else
            $display("PASS: SW");

        // BEQ
        opcode = 7'b1100011;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b000010)
            $display("FAIL: BEQ");
        else
            $display("PASS: BEQ");

        // JAL
        opcode = 7'b1101111;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b100001)
            $display("FAIL: JAL");
        else
            $display("PASS: JAL");

        // JALR
        opcode = 7'b1100111;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b100101)
            $display("FAIL: JALR");
        else
            $display("PASS: JALR");

        // LUI
        opcode = 7'b0110111;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b100100)
            $display("FAIL: LUI");
        else
            $display("PASS: LUI");

        // AUIPC
        opcode = 7'b0010111;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b100100)
            $display("FAIL: AUIPC");
        else
            $display("PASS: AUIPC");

        // Invalid opcode
        opcode = 7'b1111111;
        #10;
        if ({reg_write, mem_read, mem_write, alu_src, branch, jump} !== 6'b000000)
            $display("FAIL: Invalid opcode");
        else
            $display("PASS: Invalid opcode");

        $finish;
    end
endmodule
   