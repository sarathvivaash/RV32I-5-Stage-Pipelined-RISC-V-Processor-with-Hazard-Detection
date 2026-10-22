module hazard_detection_unit (
    input logic [4:0] rs1_id,
    input logic [4:0] rs2_id,
    input logic [4:0] rd_ex,
    input logic mem_read_ex,
    output logic stall,
    output logic pc_write,
    output logic if_id_write
);
    always_comb begin
        stall      = 1'b0;
        pc_write   = 1'b1;
        if_id_write = 1'b1;

        if (mem_read_ex && (rd_ex != 5'd0) && ((rd_ex == rs1_id) || (rd_ex == rs2_id))) begin
            stall       = 1'b1;
            pc_write    = 1'b0;
            if_id_write = 1'b0;
        end
    end
endmodule
