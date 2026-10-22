module single_cycle_cpu (
    input logic clk,
    input logic reset
);
    logic [31:0] pc_current;
    logic [31:0] pc_next;
    logic [31:0] instruction;
    logic [6:0] opcode;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [6:0] funct7;
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];
    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic alu_src;
    logic branch;
    logic jump;
    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic [31:0] write_data;
    logic [31:0] immediate;
    logic [2:0] instyp_sel;
    logic [3:0] alu_op;
    logic [31:0] alu_operand_a;
    logic [31:0] alu_operand_b;
    logic [31:0] alu_result;
    logic [31:0] memory_read_data;
    logic branch_taken;
    logic [31:0] branch_target;
    logic [31:0] jump_target;
    logic [31:0] writeback_data;

    pc pc_unit(.clk(clk),.reset(reset),.pc_next(pc_next),.pc_current(pc_current));

    instruction_memory instruction_memory_unit (.pc_current(pc_current),.instruction(instruction));

    control_unit control_unit_unit (.opcode(opcode),.reg_write(reg_write),.mem_read(mem_read),.mem_write(mem_write),
    .alu_src(alu_src),.branch(branch),.jump(jump));

    register_file register_file_unit (.clk(clk),.reset(reset),.rs1(rs1),.rs2(rs2),.rd(rd),.write_data(writeback_data),
    .write_enable(reg_write),.read_data1(read_data1),.read_data2(read_data2));

    immediate_generator immediate_generator_unit (.instruction(instruction),.instyp_sel(instyp_sel),.immediate(immediate));

    alu_control alu_control_unit (.opcode(opcode),.funct3(funct3),.funct7(funct7),.alu_op(alu_op));

    alu alu_unit (.operand_a(alu_operand_a),.operand_b(alu_operand_b),.alu_op(alu_op),.alu_result(alu_result));

    data_memory data_memory_unit (.clk(clk),.address(alu_result),.write_data(read_data2),.write_enable(mem_write),
    .read_data(memory_read_data));

    always_comb begin
        case (opcode)
            // I-type
            7'b0010011,7'b0000011,7'b1100111: instyp_sel = 3'b000;
            // S-type
            7'b0100011: instyp_sel = 3'b001;
            // U-type
            7'b0110111,7'b0010111: instyp_sel = 3'b010;
            // B-type
            7'b1100011: instyp_sel = 3'b011;
            // J-type
            7'b1101111: instyp_sel = 3'b100;
            default: instyp_sel = 3'b000;
        endcase
    end

    always_comb begin
        case (opcode)
            // AUIPC → PC + immediate
            7'b0010111: alu_operand_a = pc_current;
            // LUI → 0 + immediate
            7'b0110111: alu_operand_a = 32'd0;
            default: alu_operand_a = read_data1;
        endcase
    end

    always_comb begin
        if (alu_src)
            alu_operand_b = immediate;
        else
            alu_operand_b = read_data2;
    end

    always_comb begin
        if (mem_read)
            writeback_data = memory_read_data;
        else if (jump)
            writeback_data = pc_current + 32'd4;
        else
            writeback_data = alu_result;
    end

    assign branch_target = pc_current + immediate;
    assign jump_target = (opcode == 7'b1100111) ? ((read_data1 + immediate) & 32'hFFFFFFFE) : (pc_current + immediate);
    assign branch_taken = branch && (alu_result == 32'd0);

    always_comb begin
        pc_next = pc_current + 32'd4;
        if (branch_taken)
            pc_next = branch_target;
        if (jump)
            pc_next = jump_target;
    end
endmodule