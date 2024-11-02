`timescale 1ns / 1ns
module tb ();
   bit        reset         ;
   bit        in_giris_elde ;
   bit  [3:0] in_giris_1    ;
   bit  [3:0] in_giris_2    ;
   wire [3:0] out_cikis     ;
   wire       out_cikis_elde;
   initial begin
      reset         = 1'b1;
      #10ns;
      reset         = 1'b0;
      for (int i=0 ; i <=7 ; i++) begin
         in_giris_1    = in_giris_1 + 1;
         in_giris_2    = in_giris_2 + 1;
         #10ns;
      end
   end

   top DUT(
      .reset          (reset         ),
      .in_giris_elde  (in_giris_elde ),
      .in_giris_1     (in_giris_1    ),
      .in_giris_2     (in_giris_2    ),
      .out_cikis      (out_cikis     ),
      .out_cikis_elde (out_cikis_elde) );

   always begin
      @(out_cikis);
      $display("in1 : %d, in2 : %d, out : %d ", in_giris_1, in_giris_2,out_cikis);
      if ( out_cikis != in_giris_1 + in_giris_2)
         $fatal(1, "DUT Failed");
   end
endmodule
