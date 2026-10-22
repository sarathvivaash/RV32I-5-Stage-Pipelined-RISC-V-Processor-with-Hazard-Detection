module data_memory(
    input logic clk,
    input logic [31:0] address,
    input logic [31:0] write_data,
    input logic write_enable,
    output logic [31:0] read_data
);
    logic [31:0] memory [0:255];

    assign read_data = memory[address[9:2]];

    always_ff @(posedge clk) begin
        if (write_enable) begin
            memory[address[9:2]] <= write_data;
        end
    end
endmodule