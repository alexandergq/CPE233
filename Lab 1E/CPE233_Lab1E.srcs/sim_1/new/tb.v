`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2022 06:59:30 PM
// Design Name: 
// Module Name: tb
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


module tb();
    reg btn;
    reg clk;
    wire led; 
    wire [3:0] an;
    wire [7:0] seg;
    
    
    main my_main(
     .btn (btn),
     .clk (clk),
     .led (led),
     .seg (seg),
     .an (an)
    );
    initial
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
      initial
    begin
    
    #20
    btn = 1'b0;
    
    #20
    btn = 1'b1;

    #50
    btn = 1'b0;
    
    end

endmodule
