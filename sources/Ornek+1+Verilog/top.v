`timescale 1ns / 1ns
module top (
   input wire reset  ,
   input wire clk_in1
);
   wire clk_out1;
   wire locked  ;

   clk_wiz_0 clk_wiz_0_inst (
      // Clock out ports
      .clk_out1(clk_out1), // output clk_out1
      // Status and control signals
      .reset   (reset   ), // input reset
      .locked  (locked  ), // output locked
      // Clock in ports
      .clk_in1 (clk_in1 )
   );      // input clk_in1
endmodule
