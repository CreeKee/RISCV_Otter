`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2022 03:32:42 PM
// Design Name: 
// Module Name: BRANCH_COND_GEN
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


module BRANCH_COND_GEN(
    input [31:0] a,
    input [31:0] b,
    output br_eq,
    output br_lt,
    output br_ltu
    );
    
    assign br_eq = (a==b);
    assign br_lt = $signed(a) < $signed(b);
    assign br_ltu = a < b;
    
endmodule
