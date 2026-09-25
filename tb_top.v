//==============================================================================
//MSPAND Technologies pvt ltd//
//copyright(c) 2026 MSPAND Technologies pvt ltd
//All rights reserved
//
//
//Project: Top module Testbench
//module : tb_top
//Author : Vaideeshwaran V
//Date   : 22/06/26
//Description : Designing Test bench for the BIST top module
//
//
//Version :v1.1
//
//revision Updates
//0.1-22/06/26-initial
//
//
//============================================================================//


module tb_top;
reg str_bist,clk,rst;
wire bist_done,pass,fail;
wire [3:0] shift;

top DUT(.str_bist(str_bist),.clk(clk),.rst(rst),.bist_done(bist_done),.pass(pass),.fail(fail),.shift(shift));

initial begin
$dumpfile("top.vcd");
$dumpvars(0,tb_top);

clk=0;rst=1;str_bist=1;
#5 rst=0;

#200 $finish;

end

always #5 clk=~clk;
endmodule
