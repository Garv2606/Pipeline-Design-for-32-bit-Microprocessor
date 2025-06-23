// factorial of a number n
module micro32_tb3;

    reg clk1,clk2;
    integer k;

    micro32 mips (clk1,clk2);

    // Clock generation
    initial begin
        clk1 = 0; clk2 = 0;
        repeat (40) begin
            #5 clk1 = 1; #5 clk1 = 0;
            #5 clk2 = 1; #5 clk2 = 0;
        end
    end

    // Main test
    initial begin
        for (k = 0; k < 31; k = k + 1)
            mips.Reg[k] = k;

        mips.Mem[0] = 32'h280a00c8; // ADDI R10, R0, 200
        mips.Mem[1] = 32'h28020001; // ADDI R2, R0, 1
        mips.Mem[2] = 32'h0e94a000; // OR R20, R20, R20 (DUMMY)
        mips.Mem[3] = 32'h21430000; // LW R3, 0(R10)
        mips.Mem[4] = 32'h0e94a000; // OR R20, R20, R20 (DUMMY)
        mips.Mem[5] = 32'h14431000; // MUL R2, R2, R3
        mips.Mem[6] = 32'h2063ffff; // ADDI R3, R3, -1 (corrected!)
        mips.Mem[7] = 32'h0e94a000; // OR R20, R20, R20 (DUMMY)
        mips.Mem[8] = 32'h3460fffc; // BNEQZ R3, LOOP (-4 offset)
        mips.Mem[9] = 32'h2542fffe; // SW R2, -2(R10)
        mips.Mem[10] = 32'hfc000000; // HLT

        mips.Mem[200] = 7;

        mips.PC = 0;
        mips.HALTED = 0;
        mips.TAKEN_BRANCH = 0;

        #2000 $display("Mem[200] = %2d, Mem[198] = %6d", mips.Mem[200], mips.Mem[198]);
    end

    // Dump & Monitor
    initial begin
        $dumpfile("micro32_tb3.vcd");
        $dumpvars(0, micro32_tb3);
        $monitor("R2 : %4d", mips.Reg[2]);
        #3000 $finish;
    end

endmodule