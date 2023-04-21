`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2022 10:20:50 PM
// Design Name: 
// Module Name: PC_MOD
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


module PC_MOD(
    input reset,
    input PCWrite,
    input [31:0] jalr,
    input [31:0] branch,
    input [31:0] jal,
    input [31:0] mtvec,
    input [31:0] mepc,
    input [2:0] pcSource,
    input clk,
    output [31:0] pc
    );
        
    wire [31:0] dataThru;
        
    mux_6t1_nb #(.n(32)) pcMUX(.D0(pc+4), .D1(jalr), .D2(branch), .D3(jal), .D4(mtvec), .D5(mepc), .SEL(pcSource), .D_OUT(dataThru));
    PC programCounter(.rst(reset), .ld(PCWrite), .data(dataThru), .clk(clk), .pc(pc));
    
    
endmodule
