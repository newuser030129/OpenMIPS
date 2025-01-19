`timescale 1ns/1ns
`include "define.v"

module inst_ROM(
    input                               ce,
    input [`InstAddrBus]                addr,
    output reg[`InstBus]                inst
);
    
reg [`InstBus] inst_mem[0:`InstMemNum - 1];

initial $readmemh ("inst_rom.data", inst_mem);

    always @(*) begin
        if (ce == `ChipDisable) begin
            inst = `ZeroWord;
        end
        else begin
            inst = inst_mem[addr[`InstMemNumLog2 + 1:2]];
        end
    end

endmodule //inst_ROM
