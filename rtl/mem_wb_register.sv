module mem_wb_register (
    input logic clk,
    input logic reset,
    input logic [31:0] alu_result_in,
    input logic [31:0] memory_read_data_in,
    input logic [4:0] rd_in,
    input logic reg_write_in,
    input logic mem_read_in,
    output logic [31:0] alu_result_out,
    output logic [31:0] memory_read_data_out,
    output logic [4:0] rd_out,
    output logic reg_write_out,
    output logic mem_read_out
);
    always_ff @(posedge clk) begin
        if (reset) begin
            alu_result_out       <= 32'd0;
            memory_read_data_out <= 32'd0;
            rd_out               <= 5'd0;
            reg_write_out        <= 1'b0;
            mem_read_out         <= 1'b0;
        end
        else begin
            alu_result_out       <= alu_result_in;
            memory_read_data_out <= memory_read_data_in;
            rd_out               <= rd_in;
            reg_write_out        <= reg_write_in;
            mem_read_out         <= mem_read_in;
        end
    end
endmodule
