`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2022 10:20:50 PM
// Design Name: 
// Module Name: PC
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


module PC(
    input rst,
    input ld,
    input [31:0] data,
    input clk,
    output reg [31:0] pc = 0
    );

    always @ (posedge clk) begin
    
    if(rst) pc <= 0;
    else if(ld) pc <= data;
    else pc <= pc;
    
    end
    
endmodule
