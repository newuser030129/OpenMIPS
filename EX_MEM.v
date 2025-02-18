`timescale 1ns/1ns
`include "define.v"

module ex_mem(
    input                                   clk,
    input                                   rst,

    input [`RegAddrBus]                     ex_wd,
    input                                   ex_wreg,
    input [`RegBus]                         ex_wdata,

    input [`RegBus]                         ex_hi,
    input [`RegBus]                         ex_lo,
    input                                   ex_whilo,

    output reg [`RegBus]                    mem_hi,
    output reg [`RegBus]                    mem_lo,
    output reg [`RegBus]                    mem_whilo,

    output reg [`RegAddrBus]                mem_wd,
    output reg                              mem_wreg,
    output reg [`RegBus]                    mem_wdata
);
    
always @(posedge clk) begin
    if (rst == `RstEnable) begin
        mem_wd <= `NOPRegAddr;
        mem_wreg <= `WriteDisable;
        mem_wdata <= `ZeroWord;
        mem_hi <= `ZeroWord;
        mem_lo <= `ZeroWord;
        mem_whilo <= `WriteDisable;
    end
    else begin
        mem_wd <= ex_wd;
        mem_wreg <= ex_wreg;
        mem_wdata <= ex_wdata;
        mem_hi <= ex_hi;
        mem_lo <= ex_lo;
        mem_whilo <= ex_whilo;
    end
end

endmodule 
