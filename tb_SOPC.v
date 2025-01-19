`timescale 1ns/1ns
`include "define.v"

module tb_sopc(
    
);

reg                             rst;
reg                             clock_50;

initial begin
    clock_50 = 1'b0;
    forever begin
        #10 clock_50 = ~ clock_50;
    end
end

initial begin
    rst = `RstEnable;
    #195 rst = `RstDisable;
    #1000 $stop;
end

sopc u_sopc(
    .clk                        (clock_50),
    .rst                        (rst)
);

endmodule //tb_sopc
