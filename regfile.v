`timescale 1ns/1ns
`include "define.v"

module RegFile(
    input                   clk,
    input                   rst,

    input                   we,
    input [`RegAddrBus]     waddr,
    input [`RegBus]         wdata,

    input                   re1,
    input [`RegAddrBus]     raddr1,
    output reg[`RegBus]     rdata1,

    input                   re2,
    input [`RegAddrBus]     raddr2,
    output reg[`RegBus]     rdata2 
);

//definition of a two-dimension vector(32 32-bit register)
reg [`RegBus] regs[0:`RegNum-1];


//write
    always @(posedge clk)begin
        if (rst == `RstDisable) begin
            if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin    //in MIPS arch, the value of reg[$0] can only be 0.
                regs[waddr] <= wdata;
            end
        end
    end


//read
    always @(*) begin
        if (rst == `RstEnable) begin
            rdata1 = `ZeroWord;
        end
        else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 = `ZeroWord;     //$0 = 0
        end
        else if ((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
            rdata1 = wdata;
        end
        else if (re1 == `ReadEnable) begin
            rdata1 = regs[raddr1];
        end
        else begin
            rdata1 = `ZeroWord;
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            rdata2 = `ZeroWord;
        end
        else if (raddr2 == `RegNumLog2'h0) begin
            rdata2 = `ZeroWord;
        end
        else if ((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
            rdata2 = wdata;
        end
        else if (re2 == `ReadEnable) begin
            rdata2 = regs[raddr2];
        end
        else begin
            rdata2 = `ZeroWord;
        end
    end
    
endmodule 
