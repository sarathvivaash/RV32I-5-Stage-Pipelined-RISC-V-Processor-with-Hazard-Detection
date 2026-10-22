module alu_tb;
    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [3:0] alu_op;
    logic [31:0] alu_result;

    alu dut (.operand_a(operand_a),.operand_b(operand_b),.alu_op(alu_op),.alu_result(alu_result));

    initial begin
        $dumpfile("waveform/alu.vcd");
        $dumpvars(0, alu_tb);

        // ADD
        operand_a = 32'd10;
        operand_b = 32'd5;
        alu_op = 4'b0000;
        #10;
        if (alu_result !== 32'd15)
            $display("FAIL: ADD, result=%d", alu_result);
        else
            $display("PASS: ADD, result=%d", alu_result);

        // SUB
        operand_a = 32'd10;
        operand_b = 32'd5;
        alu_op = 4'b0001;
        #10;
        if (alu_result !== 32'd5)
            $display("FAIL: SUB, result=%d", alu_result);
        else
            $display("PASS: SUB, result=%d", alu_result);

        // AND
        operand_a = 32'b1010;
        operand_b = 32'b1100;
        alu_op = 4'b0010;
        #10;
        if (alu_result !== 32'b1000)
            $display("FAIL: AND, result=%b", alu_result);
        else
            $display("PASS: AND, result=%b", alu_result);

        // OR
        operand_a = 32'b1010;
        operand_b = 32'b1100;
        alu_op = 4'b0011;
        #10;
        if (alu_result !== 32'b1110)
            $display("FAIL: OR, result=%b", alu_result);
        else
            $display("PASS: OR, result=%b", alu_result);

        // XOR
        operand_a = 32'b1010;
        operand_b = 32'b1100;
        alu_op = 4'b0100;
        #10;
        if (alu_result !== 32'b0110)
            $display("FAIL: XOR, result=%b", alu_result);
        else
            $display("PASS: XOR, result=%b", alu_result);


        // SLT
        operand_a = -32'sd5;
        operand_b = 32'd3;
        alu_op = 4'b0101;
        #10;
        if (alu_result !== 32'd1)
            $display("FAIL: SLT, result=%d", alu_result);
        else
            $display("PASS: SLT, result=%d", alu_result);

        // SLL
        operand_a = 32'd5;
        operand_b = 32'd2;
        alu_op = 4'b0110;
        #10;
        if (alu_result !== 32'd20)
            $display("FAIL: SLL, result=%d", alu_result);
        else
            $display("PASS: SLL, result=%d", alu_result);

        // SRL
        operand_a = 32'd20;
        operand_b = 32'd2;
        alu_op = 4'b0111;
        #10;
        if (alu_result !== 32'd5)
            $display("FAIL: SRL, result=%d", alu_result);
        else
            $display("PASS: SRL, result=%d", alu_result);

        // SRA
        operand_a = -32'sd8;
        operand_b = 32'd2;
        alu_op = 4'b1000;
        #10;
        if ($signed(alu_result) !== -32'sd2)
            $display("FAIL: SRA, result=%d", $signed(alu_result));
        else
            $display("PASS: SRA, result=%d", $signed(alu_result));

        $finish;
    end
endmodule

    