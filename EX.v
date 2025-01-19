`timescale 1ns/1ns
`include "define.v"

module ex(
    input                               rst,
    
    input [`AluOpBus]                   aluop_i,
    input [`AluSelBus]                  alusel_i,
    input [`RegBus]                     reg1_i,
    input [`RegBus]                     reg2_i,
    input [`RegAddrBus]                 wd_i,
    input                               wreg_i,

    output reg[`RegAddrBus]             wd_o,
    output reg                          wreg_o,
    output reg[`RegBus]                 wdata_o
);

// 'logicout' save the result of logical operation
reg [`RegBus] logicout;            
    

    always @(*)begin
        if (rst == `RstEnable) begin
            logicout = `ZeroWord;
        end
        else begin
            case (aluop_i)
                `EXE_OR_OP: begin
                    logicout = reg1_i | reg2_i;
                end 
                default: begin
                    logicout = `ZeroWord;
                end
            endcase
        end
    end

    always @(*)begin
        wd_o = wd_i;                        // the address of target register
        wreg_o = wreg_i;                    // whether to write target register
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o = logicout;
            end 
            default: begin
                wdata_o = `ZeroWord;
            end
        endcase
    end

endmodule //ex


