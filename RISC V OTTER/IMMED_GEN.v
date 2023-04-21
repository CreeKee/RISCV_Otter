`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2022 10:36:39 PM
// Design Name: 
// Module Name: IMMED_GEN
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


module IMMED_GEN(
    input [31:7] ir,
    output [31:0] U_type,
    output [31:0] I_type,
    output [31:0] S_type,
    output [31:0] J_type,
    output [31:0] B_type
    );
    
    assign I_type[31:0] = {{21{ir[31]}}, {ir[30:25]}, {ir[24:20]}};  
    assign S_type[31:0] = {{21{ir[31]}}, {ir[30:25]}, {ir[11:7]}};  
    assign B_type[31:0] = {{20{ir[31]}}, {ir[7]}, {ir[30:25]}, {ir[11:8]}, {1'b0}};   
    
    assign U_type[31:0] = {{{ir[31:12]}},{12{1'b0}}};  
    
    assign J_type[31:0] = {{12{ir[31]}}, {ir[19:12]}, {ir[20]}, {ir[30:21]}, {1'b0}};    
    
endmodule
