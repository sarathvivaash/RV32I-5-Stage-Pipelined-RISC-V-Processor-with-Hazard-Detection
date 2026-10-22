module id_ex_register_tb;
    logic clk;
    logic reset;
    logic [31:0] pc_in;
    logic [31:0] read_data1_in;
    logic [31:0] read_data2_in;
    logic [31:0] immediate_in;
    logic [4:0]  rd_in;
    logic [3:0]  alu_op_in;
    logic reg_write_in;
    logic mem_read_in;
    logic mem_write_in;
    logic alu_src_in;
    logic branch_in;
    logic jump_in;
    logic [31:0] pc_out;
    logic [31:0] read_data1_out;
    logic [31:0] read_data2_out;
    logic [31:0] immediate_out;
    logic [4:0]  rd_out;
    logic [3:0]  alu_op_out;
    logic reg_write_out;
    logic mem_read_out;
    logic mem_write_out;
    logic alu_src_out;
    logic branch_out;
    logic jump_out;

    id_ex_register dut (.clk(clk),.reset(reset),.pc_in(pc_in),.read_data1_in(read_data1_in),.read_data2_in(read_data2_in),
    .immediate_in(immediate_in),.rd_in(rd_in),.alu_op_in(alu_op_in),.reg_write_in(reg_write_in), .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),.alu_src_in(alu_src_in),.branch_in(branch_in),.jump_in(jump_in),.pc_out(pc_out),
    .read_data1_out(read_data1_out),.read_data2_out(read_data2_out),.immediate_out(immediate_out),.rd_out(rd_out),
    .alu_op_out(alu_op_out),.reg_write_out(reg_write_out),.mem_read_out(mem_read_out),.mem_write_out(mem_write_out),
    .alu_src_out(alu_src_out),.branch_out(branch_out),.jump_out(jump_out));


    always #5 clk = ~clk;
    initial begin
        $dumpfile("waveform/id_ex_register.vcd");
        $dumpvars(0, id_ex_register_tb);

        clk = 1'b0;
        reset = 1'b1;
        pc_in = 32'd0;
        read_data1_in = 32'd0;
        read_data2_in = 32'd0;
        immediate_in = 32'd0;
        rd_in = 5'd0;
        alu_op_in = 4'b0000;
        reg_write_in = 1'b0;
        mem_read_in = 1'b0;
        mem_write_in = 1'b0;
        alu_src_in = 1'b0;
        branch_in = 1'b0;
        jump_in = 1'b0;
        #10;
        if (pc_out === 32'd0 && read_data1_out === 32'd0 && read_data2_out === 32'd0 && immediate_out === 32'd0 && 
        rd_out === 5'd0 && alu_op_out === 4'b0000 && reg_write_out === 1'b0 && mem_read_out === 1'b0 && 
        mem_write_out === 1'b0 && alu_src_out === 1'b0 && branch_out === 1'b0 && jump_out === 1'b0)
            $display("PASS: Reset");
        else
            $display("FAIL: Reset");

        reset = 1'b0;
        pc_in = 32'd0;
        read_data1_in = 32'd0;
        read_data2_in = 32'd0;
        immediate_in = 32'd10;
        rd_in = 5'd5;
        alu_op_in = 4'b0000;
        reg_write_in = 1'b1;
        mem_read_in = 1'b0;
        mem_write_in = 1'b0;
        alu_src_in = 1'b1;
        branch_in = 1'b0;
        jump_in = 1'b0;
        #10;
        if (pc_out === 32'd0 && read_data1_out === 32'd0 && read_data2_out === 32'd0 && immediate_out === 32'd10 &&
        rd_out === 5'd5 && alu_op_out === 4'b0000 && reg_write_out === 1'b1 && mem_read_out === 1'b0 && 
        mem_write_out === 1'b0 && alu_src_out === 1'b1 && branch_out === 1'b0 &&jump_out === 1'b0)
            $display("PASS: Test 1 - ADDI");
        else
            $display("FAIL: Test 1 - ADDI");

        pc_in = 32'd4;
        read_data1_in = 32'd10;
        read_data2_in = 32'd20;
        immediate_in = 32'd0;
        rd_in = 5'd3;
        alu_op_in = 4'b0000;
        reg_write_in = 1'b1;
        mem_read_in = 1'b0;
        mem_write_in = 1'b0;
        alu_src_in = 1'b0;
        branch_in = 1'b0;
        jump_in = 1'b0;
        #10;
        if (pc_out === 32'd4 && read_data1_out === 32'd10 && read_data2_out === 32'd20 && immediate_out === 32'd0 &&
        rd_out === 5'd3 && alu_op_out === 4'b0000 && reg_write_out === 1'b1 && mem_read_out === 1'b0 &&
        mem_write_out === 1'b0 && alu_src_out === 1'b0 && branch_out === 1'b0 && jump_out === 1'b0)
            $display("PASS: Test 2 - ADD");
        else
            $display("FAIL: Test 2 - ADD");

        pc_in = 32'd8;
        read_data1_in = 32'd100;
        read_data2_in = 32'd0;
        immediate_in = 32'd4;
        rd_in = 5'd7;
        alu_op_in = 4'b0000;
        reg_write_in = 1'b1;
        mem_read_in = 1'b1;
        mem_write_in = 1'b0;
        alu_src_in = 1'b1;
        branch_in = 1'b0;
        jump_in = 1'b0;
        #10;
        if (pc_out === 32'd8 && read_data1_out === 32'd100 && read_data2_out === 32'd0 && immediate_out === 32'd4 &&
        rd_out === 5'd7 && alu_op_out === 4'b0000 && reg_write_out === 1'b1 && mem_read_out === 1'b1 &&
        mem_write_out === 1'b0 && alu_src_out === 1'b1 && branch_out === 1'b0 && jump_out === 1'b0)
            $display("PASS: Test 3 - LW");
        else
            $display("FAIL: Test 3 - LW");

        pc_in = 32'd12;
        read_data1_in = 32'd100;
        read_data2_in = 32'd50;
        immediate_in = 32'd8;
        rd_in = 5'd0;
        alu_op_in = 4'b0000;
        reg_write_in = 1'b0;
        mem_read_in = 1'b0;
        mem_write_in = 1'b1;
        alu_src_in = 1'b1;
        branch_in = 1'b0;
        jump_in = 1'b0;
        #10;
        if (pc_out === 32'd12 && read_data1_out === 32'd100 && read_data2_out === 32'd50 && immediate_out === 32'd8 &&
        rd_out === 5'd0 && alu_op_out === 4'b0000 && reg_write_out === 1'b0 && mem_read_out === 1'b0 && 
        mem_write_out === 1'b1 && alu_src_out === 1'b1 && branch_out === 1'b0 && jump_out === 1'b0)
            $display("PASS: Test 4 - SW");
        else
            $display("FAIL: Test 4 - SW");
        $finish;
    end
endmodule