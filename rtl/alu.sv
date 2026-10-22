module alu(
    input logic [31:0] operand_a,
    input logic [31:0] operand_b,
    input logic [3:0] alu_op,
    output logic [31:0] alu_result
);

always_comb begin
    case(alu_op)
    4'b0000: alu_result = operand_a + operand_b; // Addition
    4'b0001: alu_result = operand_a - operand_b; // Subtraction
    4'b0010: alu_result = operand_a & operand_b; // Bitwise AND
    4'b0011: alu_result = operand_a | operand_b; // Bitwise OR
    4'b0100: alu_result = operand_a ^ operand_b; // Bitwise XOR  
    4'b0101: alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0; // Set Less Than (signed)
    4'b0110: alu_result = operand_a << operand_b[4:0]; // Logical Shift Left
    4'b0111: alu_result = operand_a >> operand_b[4:0]; // Logical Shift Right
    4'b1000: alu_result = $signed(operand_a) >>> operand_b[4:0]; // Arithmetic Shift Right
    default: alu_result = 32'd0; 
    endcase
end
endmodule 