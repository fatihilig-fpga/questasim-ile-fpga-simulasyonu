`timescale 1ns / 1ns
module tb ();
   timeunit 1ns;
   timeprecision 1ns;
   //--
   bit         reset         ;
   bit         in_giris_elde ;
   bit   [3:0] in_giris_1    ;
   bit   [3:0] in_giris_2    ;
   logic [3:0] out_cikis     ;
   logic       out_cikis_elde;
   //--
   class transaction;
      rand bit        reset ;
      rand bit        in_giris_elde ;
      rand bit  [3:0] in_giris_1    ;
      rand bit  [3:0] in_giris_2    ;

      logic [3:0] out_cikis     ;
      logic       out_cikis_elde;

      constraint c1 {in_giris_1>0; in_giris_1<6;};
      constraint c2 {reset dist {0:= 75, 1:=25};}
   endclass

   class generator;
      transaction tr;
      function new();
         tr = new();
      endfunction
      //--
      task run();
         tr.randomize();
      endtask
   endclass

   generator gen = new();
   initial begin
      in_giris_elde = 1'b0;
      for (int i=0;i<=10;i++) begin
         gen.run();
         reset      = gen.tr.reset;
         in_giris_1 = gen.tr.in_giris_1;
         in_giris_2 = gen.tr.in_giris_2;
         #10ns;
         if (( out_cikis != in_giris_1 + in_giris_2) && (reset == 1'b0))
            $fatal(1, "DUT Failed");
         if (reset == 1'b0)
            $display("in1 : %d, in2 : %d, out : %d ", in_giris_1, in_giris_2,out_cikis);
      end
   end

   top DUT(
      .reset          (reset         ),
      .in_giris_elde  (in_giris_elde ),
      .in_giris_1     (in_giris_1    ),
      .in_giris_2     (in_giris_2    ),
      .out_cikis      (out_cikis     ),
      .out_cikis_elde (out_cikis_elde) );

endmodule

