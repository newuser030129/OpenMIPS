`timescale 1ns/1ns
`include "define.v"

module sopc(
    input                           clk,
    input                           rst
);

wire [`InstAddrBus]                 inst_addr;
wire [`InstBus]                     inst;
wire                                rom_ce;

openmips u_openmips(
    .clk                            (clk),
    .rst                            (rst),

    .rom_addr_o                     (inst_addr),
    .rom_data_i                     (inst),
    .rom_ce_o                       (rom_ce)
);

inst_ROM u_inst_ROM(
    .ce                             (rom_ce),
    .addr                           (inst_addr),
    .inst                           (inst)
); 
    
endmodule //sopc

