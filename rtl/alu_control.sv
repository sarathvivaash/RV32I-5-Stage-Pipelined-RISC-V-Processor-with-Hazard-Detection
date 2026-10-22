module alu_control (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [3:0] alu_op
);
    always_comb begin
        case (opcode)                               
             7'b0110011: begin // R-type instructions
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_op = 4'b0001;       // SUB
                        else
                            alu_op = 4'b0000;       // ADD
                    end
                    3'b001: alu_op = 4'b0110; // SLL
                    3'b010: alu_op = 4'b0101; // SLT
                    3'b100: alu_op = 4'b0100; // XOR
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_op = 4'b1000;       // SRA
                        else
                            alu_op = 4'b0111;       // SRL
                    end
                    3'b110: alu_op = 4'b0011; // OR
                    3'b111: alu_op = 4'b0010; // AND
                    default: alu_op = 4'b0000;
                endcase
            end

            7'b0010011: begin // I-type arithmetic instructions
                case (funct3)
                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b001: alu_op = 4'b0110; // SLLI
                    3'b010: alu_op = 4'b0101; // SLTI
                    3'b100: alu_op = 4'b0100; // XORI
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_op = 4'b1000;       // SRAI
                        else
                            alu_op = 4'b0111;       // SRLI
                    end
                    3'b110: alu_op = 4'b0011; // ORI
                    3'b111: alu_op = 4'b0010; // ANDI
                    default: alu_op = 4'b0000;
                endcase
            end

            7'b0000011: alu_op = 4'b0000; // LW
            7'b0100011: alu_op = 4'b0000; // SW 
            7'b1100011: alu_op = 4'b0001; // BEQ  
            7'b1101111: alu_op = 4'b0000; // JAL
            7'b1100111: alu_op = 4'b0000; // JALR
            7'b0110111: alu_op = 4'b0000; // LUI
            7'b0010111: alu_op = 4'b0000; // AUIPC
            default: alu_op = 4'b0000;
        endcase
    end
endmodule
