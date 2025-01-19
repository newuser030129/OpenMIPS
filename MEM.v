`timescale 1ns/1ns
`include "define.v"

module mem(
    input                               rst,

    input [`RegAddrBus]                 wd_i,
    input                               wreg_i,
    input [`RegBus]                     wdata_i,

    output reg[`RegAddrBus]             wd_o,
    output reg                          wreg_o,
    output reg[`RegBus]                 wdata_o
);

    always @(*) begin
        if (rst == `RstEnable) begin
            wd_o = `NOPRegAddr;
            wreg_o = `WriteDisable;
            wdata_o = `ZeroWord;
        end
        else begin
            wd_o = wd_i;
            wreg_o = wreg_i;
            wdata_o = wdata_i;
        end
    end

endmodule //mem
