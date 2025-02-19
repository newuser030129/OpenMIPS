`timescale 1ns/1ns
`include "define.v"
module pc_reg(
    input                           clk,
    input                           rst,
    input [5:0]                     stall,      //from "ctrl" module
    output reg [`InstAddrBus]       pc,
    output reg                      ce
);

    always @(posedge clk ) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
        end
        else begin
            ce <= `ChipEnable;
        end
    end

    always @(posedge clk ) begin
        if (ce == `ChipDisable) begin
            pc <= 32'h00000000;
        end
        else if (stall[0] == `NonStop) begin
            pc <= pc + 4'h4;
        end
    end

endmodule