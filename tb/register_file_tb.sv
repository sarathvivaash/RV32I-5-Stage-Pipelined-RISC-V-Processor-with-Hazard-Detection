module register_file_tb;
    logic clk;
    logic reset;    
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    logic [31:0] write_data;
    logic write_enable;
    logic [31:0] read_data1;
    logic [31:0] read_data2;

    register_file dut(
        .clk(clk),.reset(reset),.rs1(rs1),.rs2(rs2),.rd(rd),.write_data(write_data),.write_enable(write_enable),
        .read_data1(read_data1),.read_data2(read_data2)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("waveform/register_file.vcd");
        $dumpvars(0, register_file_tb);

        write_enable = 1'b0;
        rs1 = 5'd0;
        rs2 = 5'd0;
        rd = 5'd0;
        write_data = 32'd0;

        rd = 5'd5;
        write_data = 32'd100;
        write_enable = 1'b1;
        @(posedge clk);
        #1;

        write_enable = 1'b0;
        rs1 = 5'd5;
        #1;
        if(read_data1 !== 32'd100) begin
            $display("FAIL: read_data1 = %h", read_data1);
        end
        else begin
            $display("PASS: read_data1 = %h", read_data1);
        end

        rd = 5'd10;
        write_data = 32'd200;
        write_enable = 1'b1;
        @(posedge clk);
        #1;

        write_enable = 1'b0;
        rs1 = 5'd5;
        rs2 = 5'd10;
        #1;
        if (read_data1 !== 32'd100) begin
            $display("FAIL: x5 = %h", read_data1);
        end
        else begin
            $display("PASS: x5 = %h", read_data1);
        end
        if (read_data2 !== 32'd200) begin
            $display("FAIL: x10 = %h", read_data2);
        end
        else begin
            $display("PASS: x10 = %h", read_data2);
        end

        write_enable = 1'b1;
        rd = 5'd0;
        write_data = 32'd999;
        write_enable = 1'b1;
        @(posedge clk);
        #1;

        write_enable = 1'b0;
        rs1 = 5'd0;
        #1;
        if(read_data1 !== 32'd0) begin
            $display("FAIL: x0 = %h", read_data1);
        end
        else begin
            $display("PASS: x0 = %h", read_data1);
        end

        $finish;
    end
endmodule
