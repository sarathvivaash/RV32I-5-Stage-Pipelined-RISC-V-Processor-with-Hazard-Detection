module data_memory_tb;
    logic clk;
    logic [31:0] address;
    logic [31:0] write_data;
    logic write_enable;
    logic [31:0] read_data;

    data_memory dut (.clk(clk),.address(address),.write_data(write_data),.write_enable(write_enable),
    .read_data(read_data));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("waveform/data_memory.vcd");
        $dumpvars(0,data_memory_tb);

        address = 32'd0;
        write_data = 32'd0;
        write_enable = 1'b0;

        // writing 100 to address 0
        address = 32'd0;
        write_data = 32'd100;
        write_enable = 1'b1;
        #10;

        if(read_data !== 32'd100) begin
            $display("FAIL: read_data = %d", read_data);
        end
        else begin
            $display("PASS: read_data = %d", read_data);
        end

        // writing 200 to address 4
        address = 32'd4;
        write_data = 32'd200;
        write_enable = 1'b1;
        #10;

        if(read_data !== 32'd200) begin
            $display("FAIL: read_data = %d", read_data);
        end
        else begin
            $display("PASS: read_data = %d", read_data);
        end

        // writing 500 to address 12
        address = 32'd12;
        write_data = 32'd500;
        write_enable = 1'b1;
        #10;

        if(read_data !== 32'd500) begin
            $display("FAIL: read_data = %d", read_data);
        end
        else begin
            $display("PASS: read_data = %d", read_data);
        end
        $finish;
    end
endmodule





  