module pc_tb;

    logic clk;
    logic reset;
    logic [31:0] pc_next;
    logic [31:0] pc_current;


    pc dut (.clk(clk),.reset(reset),.pc_next(pc_next),.pc_current(pc_current));
    
    always #5 clk = ~clk;

    initial begin

        $dumpfile("waveformbro i di/pc.vcd");
        $dumpvars(0, pc_tb);

        clk = 0;
        reset = 1;
        pc_next = 0;
        #10;
        reset = 0;
        pc_next = 4;
        #10;
        pc_next = 8;
        #10;
        pc_next = 12;
        #10;
        $finish;
    end
endmodule
    