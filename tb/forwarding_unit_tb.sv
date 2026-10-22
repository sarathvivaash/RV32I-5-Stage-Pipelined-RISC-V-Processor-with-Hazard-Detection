module forwarding_unit_tb;
    logic [4:0] rs1_ex;
    logic [4:0] rs2_ex;
    logic [4:0] rd_mem; 
    logic [4:0] rd_wb;
    logic reg_write_mem; 
    logic reg_write_wb;
    logic [1:0] forward_a; 
    logic [1:0] forward_b;

    forwarding_unit dut (.rs1_ex(rs1_ex),.rs2_ex(rs2_ex),.rd_mem(rd_mem),.reg_write_mem(reg_write_mem),.rd_wb(rd_wb),
        .reg_write_wb(reg_write_wb),.forward_a(forward_a),.forward_b(forward_b));

    initial begin
        $dumpfile("waveform/forwarding_unit.vcd");
        $dumpvars(0, forwarding_unit_tb);

        // Test 1: No forwarding required
        rs1_ex = 5'd1;
        rs2_ex = 5'd2;
        rd_mem = 5'd3;
        rd_wb = 5'd4;
        reg_write_mem = 0;
        reg_write_wb = 0;
        #10;
        if (forward_a !== 2'b00 || forward_b !== 2'b00)
            $display("FAIL: No Forwarding");
        else
            $display("PASS: No Forwarding");

        // Test 2: Forward operand A from EX/MEM
        rs1_ex = 5'd3;
        rs2_ex = 5'd2;
        rd_mem = 5'd3;
        rd_wb = 5'd4;
        reg_write_mem = 1;
        reg_write_wb = 0;
        #10;
        if (forward_a !== 2'b10 || forward_b !== 2'b00)
            $display("FAIL: EX/MEM Forward A");
        else
            $display("PASS: EX/MEM Forward A");

        // Test 3: Forward operand B from EX/MEM
        rs1_ex = 5'd1;
        rs2_ex = 5'd3;
        rd_mem = 5'd3;
        rd_wb = 5'd4;
        reg_write_mem = 1;
        reg_write_wb = 0;
        #10;
        if (forward_a !== 2'b00 || forward_b !== 2'b10)
            $display("FAIL: EX/MEM Forward B");
        else
            $display("PASS: EX/MEM Forward B");

        // Test 4: Forward operand A from MEM/WB
        rs1_ex = 5'd4;
        rs2_ex = 5'd2;
        rd_mem = 5'd3;
        rd_wb = 5'd4;
        reg_write_mem = 0;
        reg_write_wb = 1;
        #10;
        if (forward_a !== 2'b01 || forward_b !== 2'b00)
            $display("FAIL: MEM/WB Forward A");
        else
            $display("PASS: MEM/WB Forward A");

        // Test 5: Forward operand B from MEM/WB
        rs1_ex = 5'd1;
        rs2_ex = 5'd4;
        rd_mem = 5'd3;
        rd_wb = 5'd4;
        reg_write_mem = 0;
        reg_write_wb = 1;
        #10;
        if (forward_a !== 2'b00 || forward_b !== 2'b01)
            $display("FAIL: MEM/WB Forward B");
        else
            $display("PASS: MEM/WB Forward B");

        // Test 6: EX/MEM has priority over MEM/WB
        rs1_ex = 5'd3;
        rs2_ex = 5'd2;
        rd_mem = 5'd3;
        rd_wb = 5'd3;
        reg_write_mem = 1;
        reg_write_wb = 1;
        #10;
        if (forward_a !== 2'b10)
            $display("FAIL: EX/MEM Priority");
        else
            $display("PASS: EX/MEM Priority");

        // Test 7: Never forward from x0
        rs1_ex = 5'd0;
        rs2_ex = 5'd0;
        rd_mem = 5'd0;
        rd_wb = 5'd0;
        reg_write_mem = 1;
        reg_write_wb = 1;
        #10;
        if (forward_a !== 2'b00 || forward_b !== 2'b00)
            $display("FAIL: x0 Protection");
        else
            $display("PASS: x0 Protection");
        $finish;
    end
endmodule

