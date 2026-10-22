module hazard_detection_unit_tb;
    logic [4:0] rs1_id;
    logic [4:0] rs2_id;
    logic [4:0] rd_ex;
    logic mem_read_ex;
    logic stall;
    logic pc_write;
    logic if_id_write;

    hazard_detection_unit dut (.rs1_id(rs1_id),.rs2_id(rs2_id),.rd_ex(rd_ex),.mem_read_ex(mem_read_ex),.stall(stall),
    .pc_write(pc_write),.if_id_write(if_id_write));

    initial begin
        $dumpfile("waveform/hazard_detection_unit.vcd");
        $dumpvars(0, hazard_detection_unit_tb);

        // Test 1: Load-use hazard through rs1
        // EX: LW x3, 0(x1)
        // ID: ADD x5, x3, x2
        rd_ex = 5'd3;
        mem_read_ex = 1'b1;
        rs1_id = 5'd3;
        rs2_id = 5'd2;
        #10;
        if (stall !== 1'b1 || pc_write !== 1'b0 || if_id_write !== 1'b0)
            $display("FAIL: Load-use hazard rs1");
        else
            $display("PASS: Load-use hazard rs1");

        // Test 2: Load-use hazard through rs2
        // EX: LW x4, 0(x1)
        // ID: ADD x5, x2, x4
        rd_ex = 5'd4;
        mem_read_ex = 1'b1;
        rs1_id = 5'd2;
        rs2_id = 5'd4;
        #10;
        if (stall !== 1'b1 ||
            pc_write !== 1'b0 ||
            if_id_write !== 1'b0)
            $display("FAIL: Load-use hazard rs2");
        else
            $display("PASS: Load-use hazard rs2");

        // Test 3: No dependency
        // EX: LW x3, 0(x1)
        // ID: ADD x5, x4, x2
        rd_ex = 5'd3;
        mem_read_ex = 1'b1;
        rs1_id = 5'd4;
        rs2_id = 5'd2;
        #10;
        if (stall !== 1'b0 || pc_write !== 1'b1 || if_id_write !== 1'b1)
            $display("FAIL: No dependency");
        else
            $display("PASS: No dependency");

        // Test 4: EX instruction is not a load
        // EX: ADD x3, x1, x2
        // ID: ADD x5, x3, x4
        rd_ex = 5'd3;
        mem_read_ex = 1'b0;
        rs1_id = 5'd3;
        rs2_id = 5'd4;
        #10;
        if (stall !== 1'b0 || pc_write !== 1'b1 || if_id_write !== 1'b1)
            $display("FAIL: Non-load instruction");
        else
            $display("PASS: Non-load instruction");

        // Test 5: Destination is x0
        // EX: LW x0, 0(x1)
        // ID: ADD x5, x0, x2
        rd_ex = 5'd0;
        mem_read_ex = 1'b1;
        rs1_id = 5'd0;
        rs2_id = 5'd2;
        #10;
        if (stall !== 1'b0 ||
            pc_write !== 1'b1 ||
            if_id_write !== 1'b1)
            $display("FAIL: x0 protection");
        else
            $display("PASS: x0 protection");
        $finish;
    end
endmodule