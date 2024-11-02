// Define write clock and read clock
`define wrclk_period 20
`define rdclk_period 15
`timescale 1ns / 1ps
module tb ();
   // Outputs
   wire [7:0] dout       ;
   wire       full       ;
   wire       empty      ;
   wire       wr_rst_busy;
   wire       rd_rst_busy;
   // Inputs
   reg       rst    = 'd0;
   reg       wr_clk = 'd0;
   reg       rd_clk = 'd0;
   reg [7:0] din    = 'd0;
   reg       wr_en  = 'd0;
   reg       rd_en  = 'd0;

   fifo_top fifo_top_inst (
      .rst_i        (rst        ), 
      .wr_clk_i     (wr_clk     ), 
      .rd_clk_i     (rd_clk     ), 
      .din_i        (din        ), 
      .wr_en_i      (wr_en      ), 
      .rd_en_i      (rd_en      ), 
      .dout_o       (dout       ), 
      .full_o       (full       ), 
      .empty_o      (empty      ) 
   );
   //--
   always #(`wrclk_period/2) wr_clk = !wr_clk;
   always #(`rdclk_period/2) rd_clk = !rd_clk;
   //--
   initial begin
   	rst = 1'b1;
   	#100;
   	rst = 1'b0;
   end 
   //--
   integer i = 0;
   initial begin
      @(negedge (rst));
      #500;
      // WRITE
      for (i=0 ; i <= 5 ; i = i +1) begin
         @(posedge(wr_clk));
         wr_en = 1'b1;
         din = i;
      end
      wr_en = 1'b0;
      //--
      #100;
      // READ
      @(posedge(rd_clk));
      for (i=0 ; i <= 5 ; i = i +1) begin
         rd_en = 1'b1;
         @(posedge(rd_clk));
      end
      rd_en = 1'b0;
   end
endmodule

