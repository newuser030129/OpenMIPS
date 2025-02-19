`timescale 1ns/1ns
`include "define.v"

module mem_wb(
    input                                       clk,
    input                                       rst,

    input [`RegAddrBus]                         mem_wd,
    input                                       mem_wreg,
    input [`RegBus]                             mem_wdata,

    input [`RegBus]                             mem_hi,
    input [`RegBus]                             mem_lo,
    input                                       mem_whilo,

    input [5:0]                                 stall,

    output reg [`RegBus]                        wb_hi,
    output reg [`RegBus]                        wb_lo,
    output reg                                  wb_whilo,

    output reg[`RegAddrBus]                     wb_wd,
    output reg                                  wb_wreg,
    output reg [`RegBus]                        wb_wdata
);
    
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `WriteDisable;
            wb_wdata <= `ZeroWord;
            wb_hi <= `ZeroWord;
            wb_lo <= `ZeroWord;
            wb_whilo <= `WriteDisable;
        end
        else if ((stall[4] == `Stop) && stall[5] == `NonStop) begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `WriteDisable;
            wb_wdata <= `ZeroWord;
            wb_hi <= `ZeroWord;
            wb_lo <= `ZeroWord;
            wb_whilo <= `WriteDisable;
        end
        else if (stall[4] == `NonStop) begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
            wb_hi <= mem_hi;
            wb_lo <= mem_lo;
            wb_whilo <= mem_whilo;
        end
    end

endmodule //mem_wb

