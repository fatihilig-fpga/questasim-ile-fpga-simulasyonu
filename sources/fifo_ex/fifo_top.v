`timescale 1ns / 1ps
module fifo_top (
   input  wire       rst_i        ,
   input  wire       wr_clk_i     ,
   input  wire       rd_clk_i     ,
   input  wire [7:0] din_i        ,
   input  wire       wr_en_i      ,
   input  wire       rd_en_i      ,
   output wire [7:0] dout_o       ,
   output wire       full_o       ,
   output wire       empty_o      
);
   fifo_generator_0 fifo_generator_inst (
      .rst        (rst_i        ), // input wire rst
      .wr_clk     (wr_clk_i     ), // input wire wr_clk
      .rd_clk     (rd_clk_i     ), // input wire rd_clk
      .din        (din_i        ), // input wire [7 : 0] din
      .wr_en      (wr_en_i      ), // input wire wr_en
      .rd_en      (rd_en_i      ), // input wire rd_en
      .dout       (dout_o       ), // output wire [7 : 0] dout
      .full       (full_o       ), // output wire full
      .empty      (empty_o      ), // output wire empty
      .wr_rst_busy(				  ), // output wire wr_rst_busy
      .rd_rst_busy(				  )  // output wire rd_rst_busy
   );
endmodule
