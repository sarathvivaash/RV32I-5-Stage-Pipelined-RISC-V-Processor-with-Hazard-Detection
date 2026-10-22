module instruction_memory (
    input logic [31:0] pc_current,
    output logic [31:0] instruction
);
logic [31:0] instruction_memory [0:255];
initial begin
    instruction_memory[0] = 32'h00A00093;
    instruction_memory[1] = 32'h01400113;
    instruction_memory[2] = 32'h002081B3;
    instruction_memory[3] = 32'h40118233;
    instruction_memory[4] = 32'h0021F2B3;
    instruction_memory[5] = 32'h0020E333;
    instruction_memory[6] = 32'h00302023;
    instruction_memory[7] = 32'h00002383;
end

assign instruction = instruction_memory[pc_current[9:2]];
endmodule



