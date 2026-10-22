module control_unit(
    input logic [6:0] opcode,
    output logic reg_write,
    output logic mem_read,
    output logic mem_write,
    output logic alu_src,
    output logic branch,
    output logic jump
);
    always_comb begin
        case (opcode)
            7'b0110011:begin // R-type
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                alu_src = 0;
                branch = 0;
                jump = 0;
            end
            7'b0010011:begin  // I-type
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                alu_src = 1;
                branch = 0;
                jump = 0;
            end
            7'b0000011:begin  // Load
                reg_write = 1;
                mem_read = 1;
                mem_write = 0;
                alu_src = 1;
                branch = 0;
                jump = 0;
            end
            7'b0100011:begin  // Store
                reg_write = 0;
                mem_read = 0;
                mem_write = 1;
                alu_src = 1;
                branch = 0;
                jump = 0;
            end
            7'b1100011:begin    // Branch
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                alu_src = 0;
                branch = 1;
                jump = 0;
            end
            7'b1101111:begin    // JAL
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                alu_src = 0;
                branch = 0;
                jump = 1;
            end
            7'b1100111: begin   // JALR
                reg_write = 1;
                mem_read  = 0;
                mem_write = 0;
                alu_src   = 1;
                branch    = 0;
                jump      = 1;
            end
            7'b0110111:begin  // LUI
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                alu_src = 1;
                branch = 0;
                jump = 0;
            end
            7'b0010111:begin  // AUIPC
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                alu_src = 1;
                branch = 0;
                jump = 0;
            end
            default:begin
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                alu_src = 0;
                branch = 0;
                jump = 0;
            end
        endcase
    end
endmodule
