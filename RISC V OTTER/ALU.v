`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 12:42:08 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [3:0] alu_fun,
    output reg [31:0] result
    );

always @ (srcA, srcB, alu_fun) begin
    case(alu_fun)
        4'b0000: result <= srcA+srcB; //add
        4'b1000: result <= srcA-srcB; //sub
        4'b0110: result <= srcA|srcB; //or
        4'b0111: result <= srcA&srcB; //and
        4'b0100: result <= srcA^srcB; //xor
        4'b0101: result <= srcA >> srcB[4:0]; //shift right
        4'b0001: result <= srcA << srcB[4:0]; //shift left
        4'b1101: result <= $signed(srcA)  >>> srcB[4:0]; //signed shift right
        4'b0010: result <= ($signed(srcA) < $signed(srcB)) ? 1 : 0; //signed comparison
        4'b0011: result <= (srcA < srcB) ? 1:0; //unsigned comparison
        4'b1001: result <= (srcA); //load upper
        
        default: result <= 32'hDEADBEEF;
    endcase
end
endmodule
