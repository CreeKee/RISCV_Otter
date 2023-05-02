`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2022 10:25:39 PM
// Design Name: 
// Module Name: RISCV_OTTER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RISCV_OTTER(
    input RST,
    input INTR,
    input [31:0] IOBUS_IN,
    input CLK,
    output IOBUS_WR,
    output [31:0] IOBUS_OUT,
    output [31:0] IOBUS_ADDR
    );
    
    wire [31:0] jalr, branch, jal, pc, ir, U_type, I_type, S_type, J_type, B_type, rs1, rs2, CSR_reg, dout2, result, wd, srcA, srcB, mtvec, mepc;
    wire [3:0] alu_fun;
    wire [2:0] pcSource;
    wire [1:0] alu_srcB, rf_wr_sel;
    wire reset, PCWrite, memRDEN1, memRDEN2, memWE2, regWrite, alu_srcA, IO_WR, br_eq, br_lt, br_ltu, csr_WE, int_taken, csr_mie;
    
    
    PC_MOD pc_module(
    .reset(reset),
    .PCWrite(PCWrite),
    .jalr(jalr),
    .branch(branch),
    .jal(jal),
    .mtvec(mtvec),
    .mepc(mepc),
    .pcSource(pcSource),
    .clk(CLK),
    .pc(pc)
    );
    
    /*Memory OTTER_MEMORY (
    .MEM_CLK (CLK),
    .MEM_RDEN1 (memRDEN1),
    .MEM_RDEN2 (memRDEN2),
    .MEM_WE2 (memWE2),
    .MEM_ADDR1 (pc[15:2]),
    .MEM_ADDR2 (result),
    .MEM_DIN2 (rs2),
    .MEM_SIZE (ir[13:12]),
    .MEM_SIGN (ir[14]),
    .IO_IN (IOBUS_IN),
    .IO_WR (IO_WR),
    .MEM_DOUT1 (ir),
    .MEM_DOUT2 (dout2) );*/
    
    //TODO mem_valid
    OTTER_memory memory (.MEM_CLK(CLK),.MEM_ADDR1(pc),.MEM_ADDR2(result),.MEM_DIN2(rs2),
                               .MEM_WRITE2(memWE2),.MEM_READ1(memRDEN1),.MEM_READ2(memRDEN2),
                               .ERR(),.MEM_DOUT1(ir),.MEM_DOUT2(dout2),.IO_IN(IOBUS_IN),.IO_WR(IOBUS_WR),.MEM_SIZE(ir[13:12]),.MEM_SIGN(ir[14]),
                               .MEM_VALID1(mem_valid1),.MEM_VALID2(mem_valid2),.rst(reset));

    mux_4t1_nb #(.n(32)) regMUX(
    .D0(pc+4), 
    .D1(CSR_reg), 
    .D2(dout2), 
    .D3(result), 
    .SEL(rf_wr_sel), 
    .D_OUT(wd)
    );
    RegFile REG_FILE(
    .en(regWrite),
    .adr1(ir[19:15]),
    .adr2(ir[24:20]),
    .wa(ir[11:7]),
    .clk(CLK),
    .rs1(rs1),
    .rs2(rs2),
    .wd(wd)
    );
    
    IMMED_GEN IG(
    .ir(ir[31:7]),
    .U_type(U_type),
    .I_type(I_type),
    .S_type(S_type),
    .J_type(J_type),
    .B_type(B_type)
    );
    
    BRANCH_ADDR_GEN BAG(
    .PC(pc),
    .I_type(I_type),
    .J_type(J_type),
    .B_type(B_type),
    .rs1(rs1),
    .jal(jal),
    .jalr(jalr),
    .branch(branch)
    );
    
    MUX2 #(.n(32)) srcAMUX(
    .D0(rs1), 
    .D1(U_type),  
    .SEL(alu_srcA), 
    .D_OUT(srcA)
    );
    mux_4t1_nb #(.n(32)) srcBMUX(
    .D0(rs2), 
    .D1(I_type), 
    .D2(S_type), 
    .D3(pc), 
    .SEL(alu_srcB), 
    .D_OUT(srcB)
    );
    ALU alu(
    .srcA(srcA),
    .srcB(srcB),
    .alu_fun(alu_fun),
    .result(result)
    );
    
    BRANCH_COND_GEN BCG(.a(rs1), .b(rs2), .br_eq(br_eq), .br_lt(br_lt), .br_ltu(br_ltu));
    
    CU_FSM fsm(
    .RST(RST),
    .intr(INTR&csr_mie),
    .opcode(ir[6:0]),
    .func3(ir[14:12]),
    .clk(CLK),
    .pcWrite(PCWrite),
    .regWrite(regWrite),
    .memWE2(memWE2),
    .memRDEN1(memRDEN1),
    .memRDEN2(memRDEN2),
    .reset(reset),
    .int_taken(int_taken),
    .csr_WE(csr_WE)
    );
    
    CU_DCDR decoder(
    .opcode(ir[6:0]),
    .func3(ir[14:12]),
    .func7(ir[30]),
    .int_taken(int_taken),
    .br_eq(br_eq),
    .br_lt(br_lt),
    .br_ltu(br_ltu),
    .alu_fun(alu_fun),
    .alu_srcA(alu_srcA),
    .alu_srcB(alu_srcB),
    .pcSource(pcSource),
    .rf_wr_sel(rf_wr_sel)
    );
    
    CSR csr(
    .CLK(CLK),
    .RST(reset),
    .INT_TAKEN(int_taken),
    .ADDR(ir[31:20]),
    .WR_EN(csr_WE),
    .PC(pc),
    .WD(rs1),
    .CSR_MIE(csr_mie),
    .CSR_MEPC(mepc),
    .CSR_MTVEC(mtvec)
    );
    
    assign IOBUS_OUT = rs2;
    assign IOBUS_ADDR = result;
    assign IOBUS_WR = IO_WR;
        
endmodule
