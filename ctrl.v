`timescale 1ns/1ns
`include "define.v"

module ctrl(
    input                       rst,
    input                       stall_req_from_id,
    input                       stall_req_from_ex,
    output reg[5:0]             stall
);
    
    always @(*) begin
        if (rst == `RstEnable) begin
            stall = 6'b000000;
        end
        else if (stall_req_from_ex == `Stop) begin
            stall = 6'b001111;
        end
        else if (stall_req_from_id == `Stop) begin
            stall = 6'b000111;
        end
        else begin
            stall = 6'b000000;
        end
    end

endmodule //ctrl

