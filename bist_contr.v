//==============================================================================
//MSPAND Technologies pvt ltd//
//copyright(c) 2026 MSPAND Technologies pvt ltd
//All rights reserved
//
//
//Project: BIST
//module : BIST Controller
//Author : Vaideeshwaran V
//Date   : 19/06/26
//Description : Designing BIST Controller
//
//
//Version :v1.1
//
//revision Updates
//0.1-19/06/26-initial
//
//
//============================================================================//


module bist_contr(
input str_bist,clk,rst,bist_done_w,pass_w,fail_w,
output bist_done,pass,fail,
output reg pat,ra
);

always @(posedge clk)begin
if(str_bist)begin
	pat<=1'b1;
	ra<=1'b1;
end
else begin 
	pat<=1'b0;
	ra<=1'b0;
end
end

//continous assignment

assign bist_done=bist_done_w;
assign pass=pass_w;
assign fail=fail_w;
endmodule 

//testbench
/*
module tb_bist_contr;
reg str_bist,clk,rst;
wire bist_done,pass_fail;
wire pat,ra;

bist_contr dut(.str_bist(str_bist),.clk(clk),.rst(rst),.bist_done(bist_done),.pass_fail(pass_fail),.pat(pat),.ra(ra));

initial begin
$dumpfile("bist_contr.vcd");
$dumpvars(0,tb_bist_contr);

clk=0;rst=1;
#5 rst=0;str_bist=1'b0;
#5 str_bist=1'b1;
#100 $finish;

end
always #5 clk=~clk;
endmodule*/ 
	
