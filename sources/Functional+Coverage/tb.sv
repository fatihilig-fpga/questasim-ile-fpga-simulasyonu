module tb();
timeunit 1ns;
timeprecision 1ns;
logic clk = 0;
always begin #1ns clk = !clk; end

bit [2:0] mode;
covergroup cov @(posedge clk);
   mode1: coverpoint mode;
   mode2: coverpoint mode[1:0];
endgroup

cov covobj=new();

initial begin
   $display ("-------------------------");
   for (int i = 0 ; i < 10 ; i++) begin
      mode = $urandom;
      @(posedge clk);
      $display ("mode Value = %b",mode);
      $display ("Coverage1 = yuzde %0d",covobj.mode1.get_inst_coverage());
      $display ("Coverage2 = yuzde %0d",covobj.mode2.get_inst_coverage());
      $display ("-------------------------");
   end
   $finish;
end
endmodule
