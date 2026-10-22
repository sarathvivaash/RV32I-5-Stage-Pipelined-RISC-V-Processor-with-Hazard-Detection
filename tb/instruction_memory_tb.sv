module instruction_memory_tb;

    logic [31:0] pc_current;
    logic [31:0] instruction;

    instruction_memory dut (.pc_current(pc_current), .instruction(instruction));

    initial begin
        $dumpfile("waveform/instruction_memory.vcd");
        $dumpvars(0, instruction_memory_tb);

        pc_current = 32'd0;
        #10;
        if(instruction !== 32'hAAAAAAAA) begin
            $display("FAIL: PC=0, instruction=%h", instruction);
        end
        else begin
            $display("PASS: PC=0, instruction=%h", instruction);
        end

        pc_current = 32'd4;
        #10;
        if(instruction !== 32'hBBBBBBBB) begin
            $display("FAIL: PC=4, instruction=%h", instruction);
        end
        else begin
            $display("PASS: PC=4, instruction=%h", instruction);
        end

        pc_current = 32'd8;
        #10;
        if(instruction !== 32'hCCCCCCCC) begin
            $display("FAIL: PC=8, instruction=%h", instruction);
        end
        else begin
            $display("PASS: PC=8, instruction=%h", instruction);
        end

        pc_current = 32'd12;
        #10;
        if(instruction !== 32'hDDDDDDDD) begin
            $display("FAIL: PC=12, instruction=%h", instruction);
        end
        else begin
            $display("PASS: PC=12, instruction=%h", instruction);
        end
        $finish;
    end
endmodule