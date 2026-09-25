//==============================================================================
//MSPAND Technologies pvt ltd//
//copyright(c) 2026 MSPAND Technologies pvt ltd
//All rights reserved
//
//
//Project: BIST
//module : LFSR
//Author : Vaideeshwaran V
//Date   : 20/06/26
//Description : Designing LFSR for Pattern generation(BIST)
//
//
//Version :v1.1
//
//revision Updates
//0.1-20/06/26-initial
//
//
//============================================================================//


module lfsr(
input clk,rst,pat,
output pattern,
output reg pat_done,
output reg[3:0]shift
);
always@(posedge clk or posedge rst)begin
if(rst)
	shift<=4'b1010;
else if(pat)
	shift<={w1,shift[3:1]};
end
always@(posedge clk)begin
	if(shift==4'b0101)begin
		pat_done<=1'b1;
	end
	else 
		pat_done<=1'b0;
end
wire w1;
xor a1(w1,shift[3],shift[0]);

assign pattern=shift[0];
endmodule


/*//testbench
module tb_lfsr;
reg clk,rst,pat;
wire patter,pat_done;
wire [3:0] shift;

lfsr dut(.clk(clk),.rst(rst),.pat(pat),.pattern(pattern),.pat_done(pt_done),.shift(shift));

initial begin
$dumpfile("lfsr.vcd");
$dumpvars(0,tb_lfsr);

rst=1'b1;clk=1'b0;pat=1'b1;
#5 rst=1'b0;
#200 $finish;
end

always #5 clk=~clk;

endmodule*/
