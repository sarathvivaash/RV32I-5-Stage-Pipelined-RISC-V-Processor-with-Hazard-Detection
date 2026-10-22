module immediate_generator_tb;
    logic [31:0] instruction;
    logic [2:0] instyp_sel;
    logic [31:0] immediate;

    immediate_generator dut (.instruction(instruction), .instyp_sel(instyp_sel), .immediate(immediate));

    initial begin
        $dumpfile("waveform/immediate_generator.vcd");
        $dumpvars(0, immediate_generator_tb);

        // I-type
        instruction = 32'b0;
        instruction[31:20] = 12'd5;
        instyp_sel = 3'b000;
        #10;
        if(immediate !== 32'd5) begin
            $display("FAIL: I-type, immediate=%d", immediate);
        end
        else begin
            $display("PASS: I-type, immediate=%d", immediate);
        end

        // S-type
        instruction = 32'b0;
        // 52 = 000000110100
        instruction[31:25] = 7'b0000001;
        instruction[11:7]  = 5'b10100;
        instyp_sel = 3'b001;
        #10;
        if(immediate !== 32'd52) begin
            $display("FAIL: S-type, immediate=%d", immediate);
        end
        else begin
            $display("PASS: S-type, immediate=%d", immediate);
        end

        // B-type
        instruction = 32'b0;
        // branch immediate = 36
        // 36 = 0000000000100100
        instruction[31] = 1'b0; 
        instruction[7]  = 1'b0;
        instruction[30:25] = 6'b000001;
        instruction[11:8]  = 4'b0010;
        instyp_sel = 3'b011;
        #10;
        if(immediate !== 32'd36) begin
            $display("FAIL: B-type, immediate=%d", immediate);
        end
        else begin
            $display("PASS: B-type, immediate=%d", immediate);
        end

        // U-type
        //immediate = 0x12345000
        instruction = 32'b0;
        instruction[31:12] = 20'b00010010001101000101;
        instyp_sel = 3'b010;
        #10;
        if(immediate !== 32'h12345000) begin
            $display("FAIL: U-type, immediate=%h", immediate);
        end
        else begin
            $display("PASS: U-type, immediate=%h", immediate);
        end

        // J-type
        instruction = 32'b0;
        // immediate = 4612
        instruction[31]    = 1'b0;
        instruction[19:12] = 8'b00000001;
        instruction[20]    = 1'b0;
        instruction[30:21] = 10'b0100000010;
        instyp_sel = 3'b100;
        #10;

        if(immediate !== 32'd4612) begin
            $display("FAIL: J-type, immediate=%d", immediate);
        end
        else begin
            $display("PASS: J-type, immediate=%d", immediate);
        end
        $finish;
    end
endmodule




