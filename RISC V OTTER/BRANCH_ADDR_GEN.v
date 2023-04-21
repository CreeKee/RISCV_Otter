`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2022 11:24:18 PM
// Design Name: 
// Module Name: BRANCH_ADDR_GEN
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


module BRANCH_ADDR_GEN(
    input [31:0] PC,
    input [31:0] I_type,
    input [31:0] J_type,
    input [31:0] B_type,
    input [31:0] rs1,
    output [31:0] jal,
    output [31:0] branch,
    output [31:0] jalr
    );
    
    assign jal = PC+J_type;
    assign jalr = rs1+I_type;
    assign branch = PC+B_type;
    
endmodule
