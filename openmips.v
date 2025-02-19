`timescale 1ns/1ns
`include "define.v"

module openmips(
    input                                   clk,
    input                                   rst,
    
    input [`RegBus]                         rom_data_i,         //instruction fetched out from instruction memory
    output [`RegBus]                        rom_addr_o,         //output to instruction memory address
    output                                  rom_ce_o            //the 'enable' signal of instruction memory
);
    
wire [`InstAddrBus]                 pc;
wire [`InstAddrBus]                 id_pc_i;
wire [`InstBus]                     id_inst_i;


wire [`AluOpBus]                    id_aluop_o;
wire [`AluSelBus]                   id_alusel_o;
wire [`RegBus]                      id_reg1_o;
wire [`RegBus]                      id_reg2_o;
wire                                id_wreg_o;
wire [`RegAddrBus]                  id_wd_o;


wire [`AluOpBus]                    ex_aluop_i;
wire [`AluSelBus]                   ex_alusel_i;
wire [`RegBus]                      ex_reg1_i;
wire [`RegBus]                      ex_reg2_i;
wire                                ex_wreg_i;
wire [`RegAddrBus]                  ex_wd_i;


wire                                ex_wreg_o;
wire [`RegAddrBus]                  ex_wd_o;
wire [`RegBus]                      ex_wdata_o;
wire                                ex_whilo_o;
wire [`RegBus]                      ex_hi_o;
wire [`RegBus]                      ex_lo_o;


wire                                mem_wreg_i;
wire [`RegAddrBus]                  mem_wd_i;
wire [`RegBus]                      mem_wdata_i;
wire                                mem_whilo_i;
wire [`RegBus]                      mem_hi_i;
wire [`RegBus]                      mem_lo_i;


wire                                mem_wreg_o;
wire [`RegAddrBus]                  mem_wd_o;
wire [`RegBus]                      mem_wdata_o;
wire                                mem_whilo_o;
wire [`RegBus]                      mem_hi_o;
wire [`RegBus]                      mem_lo_o;


wire                                wb_wreg_i;
wire [`RegAddrBus]                  wb_wd_i;
wire [`RegBus]                      wb_wdata_i;
wire                                wb_whilo_i;
wire [`RegBus]                      wb_hi_i;
wire [`RegBus]                      wb_lo_i;
            

wire                                reg1_read;
wire                                reg2_read;
wire [`RegBus]                      reg1_data;
wire [`RegBus]                      reg2_data;
wire [`RegAddrBus]                  reg1_addr;
wire [`RegAddrBus]                  reg2_addr;


wire [`RegBus]                      hi;
wire [`RegBus]                      lo;


wire [5:0]                          stall0;  
wire                                stallreqid;
wire                                stallreqex; 


ctrl u_ctrl(
    .rst                            (rst),
    .stall_req_from_ex              (stallreqex),
    .stall_req_from_id              (stallreqid),
    .stall                          (stall0)
);

pc_reg u_pc_reg(
    .clk                            (clk),
    .rst                            (rst),
    .stall                          (stall0),
    .pc                             (pc),
    .ce                             (rom_ce_o)
);

assign rom_addr_o = pc;

if_id u_if_id(
    .clk                            (clk),
    .rst                            (rst),
    .stall                          (stall0),
    .if_pc                          (pc),
    .if_inst                        (rom_data_i),
    .id_pc                          (id_pc_i),
    .id_inst                        (id_inst_i)
);

id u_id(
    .rst                            (rst),
    .pc_i                           (id_pc_i),
    .inst_i                         (id_inst_i),
    
    // from RegFile
    .reg1_data_i                    (reg1_data),
    .reg2_data_i                    (reg2_data),

    // to RegFile
    .reg1_read_o                    (reg1_read),
    .reg2_read_o                    (reg2_read),
    .reg1_addr_o                    (reg1_addr),
    .reg2_addr_o                    (reg2_addr),

    // to 'ID/EX' module
    .aluop_o                        (id_aluop_o),
    .alusel_o                       (id_alusel_o),
    .reg1_o                         (id_reg1_o),
    .reg2_o                         (id_reg2_o),
    .wd_o                           (id_wd_o),
    .wreg_o                         (id_wreg_o),

    // new port for data forwarding
    .ex_wreg_i                      (ex_wreg_o),
    .ex_wdata_i                     (ex_wdata_o),
    .ex_wd_i                        (ex_wd_o),
    .mem_wreg_i                     (mem_wreg_o),
    .mem_wdata_i                    (mem_wdata_o),
    .mem_wd_i                       (mem_wd_o),

    .stallreq_id                    (stallreqid)
);

RegFile u_RegFile(
    .clk                            (clk),
    .rst                            (rst),
    .we                             (wb_wreg_i),
    .waddr                          (wb_wd_i),
    .wdata                          (wb_wdata_i),
    .re1                            (reg1_read),
    .raddr1                         (reg1_addr),
    .rdata1                         (reg1_data),
    .re2                            (reg2_read),
    .raddr2                         (reg2_addr),
    .rdata2                         (reg2_data)
);

id_ex u_id_ex(
    .clk                            (clk),
    .rst                            (rst),

    .stall                          (stall0),
    
    //from 'ID' module
    .id_aluop                       (id_aluop_o),
    .id_alusel                      (id_alusel_o),
    .id_reg1                        (id_reg1_o),
    .id_reg2                        (id_reg2_o),
    .id_wd                          (id_wd_o),
    .id_wreg                        (id_wreg_o),

    //to 'EX' module
    .ex_aluop                       (ex_aluop_i),
    .ex_alusel                      (ex_alusel_i),
    .ex_reg1                        (ex_reg1_i),
    .ex_reg2                        (ex_reg2_i),
    .ex_wd                          (ex_wd_i),
    .ex_wreg                        (ex_wreg_i)
);

ex u_ex(
    .rst                            (rst),

    //from 'ID/EX' module
    .aluop_i                        (ex_aluop_i),
    .alusel_i                       (ex_alusel_i),
    .reg1_i                         (ex_reg1_i),
    .reg2_i                         (ex_reg2_i),
    .wd_i                           (ex_wd_i),
    .wreg_i                         (ex_wreg_i),

    //to 'EX/MEM' module
    .wd_o                           (ex_wd_o),
    .wreg_o                         (ex_wreg_o),
    .wdata_o                        (ex_wdata_o),

    //connected to HI/LO register
    .hi_i                           (hi),
    .lo_i                           (lo),
    .wb_whilo_i                     (wb_whilo_i),
    .wb_hi_i                        (wb_hi_i),
    .wb_lo_i                        (wb_lo_i),
    .mem_whilo_i                    (mem_whilo_o),
    .mem_hi_i                       (mem_hi_o),
    .mem_lo_i                       (mem_lo_o),

    .whilo_o                        (ex_whilo_o),
    .hi_o                           (ex_hi_o),
    .lo_o                           (ex_lo_o),

    .stallreq_ex                     (stallreqex)
);

ex_mem u_ex_mem(
    .clk                            (clk),
    .rst                            (rst),

    .stall                          (stall0),
    
    //from 'EX' module
    .ex_wd                          (ex_wd_o),
    .ex_wreg                        (ex_wreg_o),
    .ex_wdata                       (ex_wdata_o),

    //to 'MEM' module
    .mem_wd                         (mem_wd_i),
    .mem_wreg                       (mem_wreg_i),
    .mem_wdata                      (mem_wdata_i),

    //connected to HI/LO register
    .ex_whilo                       (ex_whilo_o),
    .ex_hi                          (ex_hi_o),
    .ex_lo                          (ex_lo_o),

    .mem_whilo                      (mem_whilo_i),
    .mem_hi                         (mem_hi_i),
    .mem_lo                         (mem_lo_i)
);

mem u_mem(
    .rst                            (rst),
    
    //from 'EX/MEM' module
    .wd_i                           (mem_wd_i),
    .wreg_i                         (mem_wreg_i),
    .wdata_i                        (mem_wdata_i),

    //to 'MEM/WB' module
    .wd_o                           (mem_wd_o),
    .wreg_o                         (mem_wreg_o),
    .wdata_o                        (mem_wdata_o),

    //connected to HI/LO register
    .whilo_i                        (mem_whilo_i),
    .hi_i                           (mem_hi_i),
    .lo_i                           (mem_lo_i),

    .whilo_o                        (mem_whilo_o),
    .hi_o                           (mem_hi_o),
    .lo_o                           (mem_lo_o)
);

mem_wb u_mem_wb(
    .clk                            (clk),
    .rst                            (rst),

    .stall                          (stall0),

    //from 'MEM' module
    .mem_wd                         (mem_wd_o),
    .mem_wreg                       (mem_wreg_o),
    .mem_wdata                      (mem_wdata_o),

    //to 'WB'
    .wb_wd                          (wb_wd_i),
    .wb_wreg                        (wb_wreg_i),
    .wb_wdata                       (wb_wdata_i),

    //connected to HI/LO register
    .mem_whilo                      (mem_whilo_o),
    .mem_hi                         (mem_hi_o),
    .mem_lo                         (mem_lo_o),

    .wb_whilo                       (wb_whilo_i),
    .wb_hi                          (wb_hi_i),
    .wb_lo                          (wb_lo_i)
);

hilo_reg u_hilo_reg(
    .clk                            (clk),
    .rst                            (rst),

    .we                             (wb_whilo_i),
    .hi_i                           (wb_hi_i),
    .lo_i                           (wb_lo_i),
    
    .hi_o                           (hi),
    .lo_o                           (lo)
);

endmodule //openmips


