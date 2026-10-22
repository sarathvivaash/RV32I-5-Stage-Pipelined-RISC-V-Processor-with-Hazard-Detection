module pipelined_cpu (
    input logic clk,
    input logic reset
);
    logic [31:0] pc_current, pc_next;
    logic [31:0] instruction_if;
    logic [31:0] pc_id, instruction_id;
    logic [6:0] opcode_id, funct7_id;
    logic [4:0] rs1_id, rs2_id, rd_id;
    logic [2:0] funct3_id, instyp_sel_id;
    logic [3:0] alu_op_id;
    logic [31:0] read_data1_id, read_data2_id;
    logic [31:0] read_data1_rf, read_data2_rf;
    logic [31:0] immediate_id;
    logic reg_write_id, mem_read_id, mem_write_id;
    logic alu_src_id, branch_id, jump_id;
    logic [31:0] writeback_data;
    logic [31:0] pc_ex;
    logic [31:0] read_data1_ex, read_data2_ex;
    logic [31:0] immediate_ex;
    logic [4:0] rd_ex, rs1_ex, rs2_ex;
    logic [3:0] alu_op_ex;
    logic reg_write_ex, mem_read_ex, mem_write_ex;
    logic alu_src_ex, branch_ex, jump_ex;
    logic [31:0] forwarded_data_a, forwarded_data_b;
    logic [31:0] alu_operand_a, alu_operand_b;
    logic [31:0] alu_result_ex;
    logic [1:0] forward_a, forward_b;
    logic [31:0] alu_result_mem, write_data_mem;
    logic [4:0] rd_mem;
    logic reg_write_mem, mem_read_mem, mem_write_mem;
    logic [31:0] memory_read_data;
    logic [31:0] alu_result_wb, memory_read_data_wb;
    logic [4:0] rd_wb;
    logic reg_write_wb, mem_read_wb;
    logic stall, pc_write, if_id_write;
    logic [4:0] hazard_rs1_id, hazard_rs2_id;
    logic branch_taken, redirect;
    logic flush_if_id;
    logic [31:0] branch_target, jump_target;
    logic [31:0] alu_result_to_mem;

    pc pc_unit (.clk(clk),.reset(reset),.pc_next(pc_next),.pc_current(pc_current));

    instruction_memory instruction_memory_unit (.pc_current(pc_current),.instruction(instruction_if));

    assign redirect = branch_taken || jump_ex;
    assign flush_if_id = redirect;

    if_id_register if_id_unit (.clk(clk),.reset(reset),.enable(if_id_write),.flush(flush_if_id),.pc_in(pc_current),
    .instruction_in(instruction_if),.pc_out(pc_id),.instruction_out(instruction_id));

    assign opcode_id = instruction_id[6:0];
    assign rd_id     = instruction_id[11:7];
    assign funct3_id = instruction_id[14:12];
    assign rs1_id    = instruction_id[19:15];
    assign rs2_id    = instruction_id[24:20];
    assign funct7_id = instruction_id[31:25];

    control_unit control_unit_id (.opcode(opcode_id),.reg_write(reg_write_id),.mem_read(mem_read_id),.mem_write(mem_write_id),
    .alu_src(alu_src_id),.branch(branch_id),.jump(jump_id));

    always_comb begin
        case (opcode_id)
            7'b0100011: instyp_sel_id = 3'b001; // S-type
            7'b0110111,
            7'b0010111: instyp_sel_id = 3'b010; // U-type
            7'b1100011: instyp_sel_id = 3'b011; // B-type
            7'b1101111: instyp_sel_id = 3'b100; // J-type
            default:    instyp_sel_id = 3'b000; // I-type
        endcase
    end

    immediate_generator immediate_generator_id (.instruction(instruction_id),.instyp_sel(instyp_sel_id),
    .immediate(immediate_id));

    alu_control alu_control_id (.opcode(opcode_id),.funct3(funct3_id),.funct7(funct7_id),.alu_op(alu_op_id));

    register_file register_file_unit (.clk(clk),.reset(reset),.rs1(rs1_id),.rs2(rs2_id),.rd(rd_wb),.write_data(writeback_data),
    .write_enable(reg_write_wb),.read_data1(read_data1_rf),.read_data2(read_data2_rf));

    always_comb begin
        read_data1_id = read_data1_rf;
        read_data2_id = read_data2_rf;

        if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs1_id))
            read_data1_id = writeback_data;

        if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs2_id))
            read_data2_id = writeback_data;
    end

    always_comb begin
        hazard_rs1_id = 5'd0;
        hazard_rs2_id = 5'd0;
        case (opcode_id)
            7'b0110011: begin // R-type
                hazard_rs1_id = rs1_id;
                hazard_rs2_id = rs2_id;
            end
            7'b0010011, // I-type ALU
            7'b0000011, // LW
            7'b1100111: // JALR
                hazard_rs1_id = rs1_id;
            7'b0100011, // SW
            7'b1100011: begin // Branch
                hazard_rs1_id = rs1_id;
                hazard_rs2_id = rs2_id;
            end
            default: begin
                hazard_rs1_id = 5'd0;
                hazard_rs2_id = 5'd0;
            end
        endcase
    end

    hazard_detection_unit hazard_unit (.rs1_id(hazard_rs1_id),.rs2_id(hazard_rs2_id),.rd_ex(rd_ex),.mem_read_ex(mem_read_ex),
    .stall(stall),.pc_write(pc_write),.if_id_write(if_id_write));

    always_comb begin
        if (redirect)
            pc_next = jump_ex ? jump_target : branch_target;
        else if (pc_write)
            pc_next = pc_current + 32'd4;
        else
            pc_next = pc_current;
    end

    id_ex_register id_ex_unit (.clk(clk),.reset(reset),.pc_in(pc_id),.read_data1_in(read_data1_id),.read_data2_in(read_data2_id),
    .immediate_in(immediate_id),.rd_in(rd_id),.alu_op_in(alu_op_id),.reg_write_in((stall || redirect) ? 1'b0 : reg_write_id),
    .mem_read_in((stall || redirect) ? 1'b0 : mem_read_id),.mem_write_in((stall || redirect) ? 1'b0 : mem_write_id),
    .alu_src_in((stall || redirect) ? 1'b0 : alu_src_id),.branch_in((stall || redirect) ? 1'b0 : branch_id),
    .jump_in((stall || redirect) ? 1'b0 : jump_id),.pc_out(pc_ex),.read_data1_out(read_data1_ex),.read_data2_out(read_data2_ex),
    .immediate_out(immediate_ex),.rd_out(rd_ex),.alu_op_out(alu_op_ex),.reg_write_out(reg_write_ex),.mem_read_out(mem_read_ex),
    .mem_write_out(mem_write_ex),.alu_src_out(alu_src_ex),.branch_out(branch_ex),.jump_out(jump_ex));

    always_ff @(posedge clk) begin
        if (reset || stall || redirect) begin
            rs1_ex <= 5'd0;
            rs2_ex <= 5'd0;
        end
        else begin
            rs1_ex <= rs1_id;
            rs2_ex <= rs2_id;
        end
    end

    forwarding_unit forwarding_unit_ex (.rs1_ex(rs1_ex),.rs2_ex(rs2_ex),.rd_mem(rd_mem),.reg_write_mem(reg_write_mem),
    .rd_wb(rd_wb),.reg_write_wb(reg_write_wb),.forward_a(forward_a),.forward_b(forward_b));

    always_comb begin
        case (forward_a)
            2'b10:   forwarded_data_a = alu_result_mem;
            2'b01:   forwarded_data_a = writeback_data;
            default: forwarded_data_a = read_data1_ex;
        endcase

        case (forward_b)
            2'b10:   forwarded_data_b = alu_result_mem;
            2'b01:   forwarded_data_b = writeback_data;
            default: forwarded_data_b = read_data2_ex;
        endcase
    end

    assign alu_operand_a = forwarded_data_a;
    assign alu_operand_b =
        alu_src_ex ? immediate_ex : forwarded_data_b;

    alu alu_unit (.operand_a(alu_operand_a),.operand_b(alu_operand_b),.alu_op(alu_op_ex),.alu_result(alu_result_ex));

    assign branch_target = pc_ex + immediate_ex;
    assign jump_target = (alu_src_ex) ? ((forwarded_data_a + immediate_ex) & 32'hFFFFFFFE) : (pc_ex + immediate_ex);
    assign branch_taken = branch_ex && (alu_result_ex == 32'd0);
    assign alu_result_to_mem = jump_ex ? (pc_ex + 32'd4) : alu_result_ex;

    ex_mem_register ex_mem_unit (.clk(clk),.reset(reset),.alu_result_in(alu_result_to_mem),.write_data_in(forwarded_data_b),
    .rd_in(rd_ex),.reg_write_in(reg_write_ex),.mem_read_in(mem_read_ex),.mem_write_in(mem_write_ex),.alu_result_out(alu_result_mem),
    .write_data_out(write_data_mem),.rd_out(rd_mem),.reg_write_out(reg_write_mem),.mem_read_out(mem_read_mem),
    .mem_write_out(mem_write_mem));

    data_memory data_memory_unit (.clk(clk),.address(alu_result_mem),.write_data(write_data_mem),.write_enable(mem_write_mem),
    .read_data(memory_read_data));

    
    mem_wb_register mem_wb_unit (.clk(clk),.reset(reset),.alu_result_in(alu_result_mem),.memory_read_data_in(memory_read_data),
    .rd_in(rd_mem),.reg_write_in(reg_write_mem),.mem_read_in(mem_read_mem),.alu_result_out(alu_result_wb),
    .memory_read_data_out(memory_read_data_wb),.rd_out(rd_wb),.reg_write_out(reg_write_wb),.mem_read_out(mem_read_wb));

    always_comb begin
        if (mem_read_wb)
            writeback_data = memory_read_data_wb;
        else
            writeback_data = alu_result_wb;
    end
endmodule
