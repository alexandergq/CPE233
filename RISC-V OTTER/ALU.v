`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2022 11:01:06 PM
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


module alu(A, B, alu_fun, alu_out);

    input [31:0] A; 
    input [31:0] B;
    input [3:0] alu_fun;
    
    output reg [31:0] alu_out;
    
    always @ (*)
    begin
        case (alu_fun)
        
        4'b0000: alu_out = A + B;                    //Add
        4'b1000: alu_out = A - B;                    //Sub
        4'b0110: alu_out = A | B;                    //OR
        4'b0111: alu_out = A & B;           //AND
        4'b0100: alu_out = A ^ B;           //XOR
        4'b0101: alu_out = A >> B[4:0];     //Shift Right Logical
        4'b0001: alu_out = A << B[4:0];     //Shift Left Logical
        4'b1101: alu_out = $signed(A) >>> B[4:0];    //Shift Right Arithmetic
        4'b0010: alu_out = ($signed(A) < $signed(B)) ? 1 : 0;   //Set Less Than (Signed)       
        4'b0011: alu_out = ((A) < (B)) ? 1 : 0; //Set Less Than (Unsigned)
        4'b1001: alu_out = A;   //Load Upper Immediate 
        
        default alu_out = 32'hDEADBEEF;
        endcase
    end
    
    


endmodule
