`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Alexander Quintanilla
// 
// Create Date: 01/04/2022 08:30:09 PM
// Design Name: 
// Module Name: main
// Project Name: Prime Number Checker
// Target Devices: 
// Tool Versions: 
// Description: Checks the data in ROM for any prime numbers,
//              writes them to RAM, then displays on Basys3 Board.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main(btn, clk, an, seg, led);

input btn, clk;
output [3:0] an; 
output [7:0] seg; 
output led;

wire nclk, clr;
wire up1, up2, up3;
wire [3:0] rom_count;
wire [7:0] rom_data;
wire [3:0] pnc_count;
wire [3:0] ram_count;
wire [7:0] ram_data_in;
wire [7:0] ram_data_out;
wire my_rco;
wire my_DONE;
wire my_PRIME;
wire my_we;
wire pnc_rco;
wire ram_rco;
wire clr_ctrl; 
wire eq;

parameter my_test = 0; 


//ROM Counter
 counter #(.n(4)) my_rom_counter (
     .clk   (nclk), 
     .clr   (clr), 
     .up    (up1), 
     .ld    (0), 
     .D     (0), 
     .count (rom_count), 
     .rco   (my_rco)   );
     
//ROM
   ROM_16x8 my_ROM (
      .addr  (rom_count),  
      .data  (rom_data),  
      .rd_en (1)    );
      
//Prime Number Checker
  prime_num_check  my_prime (
      .start (my_START),
      .test  (my_test),
      .clk   (clk),
      .num   ({2'b00,rom_data}),
      .DONE  (my_DONE),
      .PRIME (my_PRIME)     );
      
//PNC Counter
 counter #(.n(4)) my_pnc_cntr (
     .clk   (nclk), 
     .clr   (clr), 
     .up    (up3), 
     .ld    (0), 
     .D     (0), 
     .count (pnc_count), 
     .rco   (pnc_rco)   );
     
//RAM Counter
 counter #(.n(4)) my_ram_counter (
     .clk   (nclk), 
     .clr   (clr_ctrl2), 
     .up    (up2), 
     .ld    (0), 
     .D     (0), 
     .count (ram_count), 
     .rco   (ram_rco)   );
     
//Comparator
      comp_nb #(.n(16)) MY_COMP (
          .a  (ram_count), 
          .b  (pnc_count), 
          .eq (eq), 
          .gt (0), 
          .lt (0)
          );
     
     assign clr_ctrl2 = clr | (eq & clr_ctrl); 
     
//RAM
  ram_single_port #(.n(4),.m(8)) my_ram (
      .data_in  (rom_data),  // m spec
      .addr     (ram_count),  // n spec 
      .we       (my_we),
      .clk      (nclk),
      .data_out (ram_data_out)
      );
      
//FSM
     fsm_template my_fsm(
        .rco (my_rco),
        .clk (nclk),
        .btn (btn),
        .my_DONE (my_DONE),
        .my_PRIME (my_PRIME),
        .my_START (my_START),
        .my_we (my_we),
        .up1 (up1),
        .up2 (up2),
        .up3 (up3),
        .clr_ctrl (clr_ctrl),
        .clr (clr)
     );

//Clock Divider
      clk_2n_div_test #(.n(25)) MY_DIV (
          .clockin   (clk), 
          .fclk_only (my_test),          
          .clockout  (nclk)   );
          
//Univ SSEG
  univ_sseg my_univ_sseg (
     .cnt1    ({6'b00_0000,ram_data_out}), 
     .cnt2    ({3'b000,ram_count}), 
     .valid   (1), 
     .dp_en   (0), 
     .dp_sel  (0), 
     .mod_sel (2'b01),
     .sign    (0), 
     .clk     (clk), 
     .ssegs   (seg), 
     .disp_en (an)    );

     
     
endmodule
