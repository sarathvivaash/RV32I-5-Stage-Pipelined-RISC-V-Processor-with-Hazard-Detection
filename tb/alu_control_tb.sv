module alu_control_tb;
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [3:0] alu_op;

    alu_control dut (.opcode(opcode),.funct3(funct3),.funct7(funct7),.alu_op(alu_op));

    initial begin
        $dumpfile("waveform/alu_control.vcd");
        $dumpvars(0, alu_control_tb);
        // R-TYPE INSTRUCTIONS
        // ADD
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: R-type ADD");
        else
            $display("PASS: R-type ADD");
        // SUB
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #10;
        if (alu_op !== 4'b0001)
            $display("FAIL: R-type SUB");
        else
            $display("PASS: R-type SUB");
        // SLL
        opcode = 7'b0110011;
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0110)
            $display("FAIL: R-type SLL");
        else
            $display("PASS: R-type SLL");
        // SLT
        opcode = 7'b0110011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0101)
            $display("FAIL: R-type SLT");
        else
            $display("PASS: R-type SLT");
        // XOR
        opcode = 7'b0110011;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0100)
            $display("FAIL: R-type XOR");
        else
            $display("PASS: R-type XOR");
        // SRL
        opcode = 7'b0110011;
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0111)
            $display("FAIL: R-type SRL");
        else
            $display("PASS: R-type SRL");
        // SRA
        opcode = 7'b0110011;
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #10;
        if (alu_op !== 4'b1000)
            $display("FAIL: R-type SRA");
        else
            $display("PASS: R-type SRA");
        // OR
        opcode = 7'b0110011;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0011)
            $display("FAIL: R-type OR");
        else
            $display("PASS: R-type OR");
        // AND
        opcode = 7'b0110011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0010)
            $display("FAIL: R-type AND");
        else
            $display("PASS: R-type AND");

        // I-TYPE INSTRUCTIONS
        // ADDI
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: ADDI");
        else
            $display("PASS: ADDI");
        // SLLI
        opcode = 7'b0010011;
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0110)
            $display("FAIL: SLLI");
        else
            $display("PASS: SLLI");
        // SLTI
        opcode = 7'b0010011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0101)
            $display("FAIL: SLTI");
        else
            $display("PASS: SLTI");
        // XORI
        opcode = 7'b0010011;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0100)
            $display("FAIL: XORI");
        else
            $display("PASS: XORI");
        // SRLI
        opcode = 7'b0010011;
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0111)
            $display("FAIL: SRLI");
        else
            $display("PASS: SRLI");
        // SRAI
        opcode = 7'b0010011;
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #10;
        if (alu_op !== 4'b1000)
            $display("FAIL: SRAI");
        else
            $display("PASS: SRAI");
        // ORI
        opcode = 7'b0010011;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0011)
            $display("FAIL: ORI");
        else
            $display("PASS: ORI");
        // ANDI
        opcode = 7'b0010011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0010)
            $display("FAIL: ANDI");
        else
            $display("PASS: ANDI");

        // MEMORY / BRANCH / JUMP
        // LW → ADD
        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: LW");
        else
            $display("PASS: LW");
        // SW → ADD
        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: SW");
        else
            $display("PASS: SW");
        // BEQ → SUB
        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0001)
            $display("FAIL: BEQ");
        else
            $display("PASS: BEQ");
        // JAL → ADD
        opcode = 7'b1101111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: JAL");
        else
            $display("PASS: JAL");
        // JALR → ADD
        opcode = 7'b1100111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: JALR");
        else
            $display("PASS: JALR");
        // LUI → ADD
        opcode = 7'b0110111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: LUI");
        else
            $display("PASS: LUI");
        // AUIPC → ADD
        opcode = 7'b0010111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: AUIPC");
        else
            $display("PASS: AUIPC");

        // INVALID OPCODE
        opcode = 7'b1111111;
        funct3 = 3'b111;
        funct7 = 7'b1111111;
        #10;
        if (alu_op !== 4'b0000)
            $display("FAIL: Invalid opcode");
        else
            $display("PASS: Invalid opcode");
        $finish;
    end
endmodule