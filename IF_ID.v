`timescale 1ns/1ns
`include "define.v"
module if_id(
    input                           rst,
    input                           clk,
    input [`InstAddrBus]            if_pc,
    input [`InstBus]                if_inst,

    output reg[`InstAddrBus]        id_pc,
    output reg[`InstBus]            id_inst
);
    
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end

endmodule //if_id
