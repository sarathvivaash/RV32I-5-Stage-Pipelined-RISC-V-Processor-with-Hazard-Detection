module register_file (
    input logic clk,
    input logic reset,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] write_data,
    input logic write_enable,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);
logic [31:0] registers [0:31];

always_ff@(posedge clk) begin
    if(reset) begin
        registers[0] <= 32'd0;
    end
    else if(write_enable && rd != 5'd0) begin
        registers[rd] <= write_data;
    end
end
assign read_data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
assign read_data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];
endmodule