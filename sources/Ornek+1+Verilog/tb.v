`timescale 1ns/1ps
module tb ();
   reg clk_i = 1'b0;
   reg rst_i = 1'b1;
   top top_inst (
      .reset  (rst_i),
      .clk_in1(clk_i)
   );

   always #5 clk_i = ~clk_i;

   initial begin
      #100 rst_i = 1'b0;
      // #100 rst_i = 1'b1;
   end
   initial begin
      $monitor("Reset signal: %0b",rst_i);
   end
   initial begin
      #1000;
      $finish;
   end
endmodule