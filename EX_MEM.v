`timescale 1ns/1ns
`include "define.v"

module ex_mem(
    input                                   clk,
    input                                   rst,

    input [`RegAddrBus]                     ex_wd,
    input                                   ex_wreg,
    input [`RegBus]                         ex_wdata,

    output reg [`RegAddrBus]                mem_wd,
    output reg                              mem_wreg,
    output reg [`RegBus]                    mem_wdata
);
    
always @(posedge clk) begin
    if (rst == `RstEnable) begin
        mem_wd <= `NOPRegAddr;
        mem_wreg <= `WriteDisable;
        mem_wdata <= `ZeroWord;
    end
    else begin
        mem_wd <= ex_wd;
        mem_wreg <= ex_wreg;
        mem_wdata <= ex_wdata;
    end
end

endmodule 
