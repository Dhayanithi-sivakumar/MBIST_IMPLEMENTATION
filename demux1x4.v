//==============================================================================
//MSPAND Technologies pvt ltd//
//copyright(c) 2026 MSPAND Technologies pvt ltd
//All rights reserved
//
//
//Project: Demux
//module : Demux1x4 
//Author : Vaideeshwaran V
//Date   : 19/06/26
//Description : Designing 1x4 Demux
//
//
//Version :v1.1
//
//revision Updates
//0.1-19/06/26-initial
//
//
//============================================================================//


module demux1x4(y0,y1,y2,y3,s0,s1,i);
input i,s0,s1;
output y0,y1,y2,y3;

assign #5 y0=~s1&~s0&i;
assign #5 y1=s1&~s0&i;
assign #5 y2=~s1&s0&i;
assign #5 y3=s1&s0&i;

endmodule

/*//testbench
module tb_demux;
reg i,s0,s1;
wire y0,y1,y2,y3;

demux1x4 dut(.i(i),.s0(s0),.s1(s1),.y0(y0),.y1(y1),.y2(y2),.y3(y3));

initial begin
$dumpfile("demux.vcd");
$dumpvars(0,tb_demux);

i=1;s0=0;s1=0;
#5 s0=0;s1=1;
#5 s0=1;s1=0;
#5 s0=1;s1=1;

#50 $finish;

end
endmodule*/
