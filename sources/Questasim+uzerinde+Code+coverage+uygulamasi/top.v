`timescale 1ns / 1ns
module top (
   input             clk_i   ,
   input             rst_i   ,
   input  wire       button_i,
   input  wire [3:0] sw_i    ,
   output reg  [3:0] led_o
);
   reg [ 3:0] state ;
   reg [31:0] dina_r;
   parameter [3:0]   S0 = 4'b0001,
      S1 = 4'b0010,
      S2 = 4'b0100,
      S3 = 4'b1000;
   always @(posedge (clk_i)) begin
      if (rst_i == 1'b1) begin
         state  <= S0;
         dina_r <= 'd0;
         led_o  <= 4'd0;
      end else begin
         case (state)
            S0 : begin
               if (button_i == 1'b1) begin
                  dina_r <= {24'd0, sw_i};
                  state  <= S1;
               end else begin
                  dina_r <= 32'd0;
                  state  <= S0;
               end
               led_o <= 4'd0;
            end
            S1 : begin
               if (button_i == 1'b1) begin
                  dina_r <= {24'd0, sw_i};
                  state  <= S2;
               end else begin
                  dina_r <= 32'd0;
                  state  <= S1;
               end
               led_o <= 4'd0;
            end
            S2 : begin
               if (button_i == 1'b1) begin
                  state <= S1; // S3
                  led_o <= 1'b1;
               end else begin
                  state <= S2;
                  led_o <= 4'd0;
               end
            end
            S3 : begin
               if (button_i == 1'b1) begin
                  state <= S0;
                  led_o <= 4'b0001;
               end else begin
                  state <= S3;
                  led_o <= 4'd0;
               end
            end
            default : begin
               state <= S0;
            end
         endcase
      end
   end
endmodule
