`timescale 1ns/1ps

module tb ();
   reg        clk_i    = 1'b0;
   reg        rst_i    = 1'b1;
   reg        button_i = 1'b0;
   reg  [3:0] sw_i     = 'd0 ;
   wire [3:0] led_o          ;

   top top_inst (
      .clk_i   (clk_i   ),
      .rst_i   (rst_i   ),
      .button_i(button_i),
      .sw_i    (sw_i    ),
      .led_o   (led_o   )
   );

   always #5 clk_i = ~clk_i;

   initial begin
      #100 rst_i = 1'b0;
   end

   initial begin
      sw_i = 'd1;
      button_i = 0;
      @(negedge (rst_i));
      #100;
      repeat(2) begin
         button_i = 1;
         sw_i = sw_i + 1 ;
         #20;
         button_i = 0;
         #100;
         $display("Value of sw_i is: %0d",sw_i);
      end

      repeat(2) begin
         button_i = 1;
         #20;
         button_i = 0;
         #100;
      end
      $finish;
   end


endmodule