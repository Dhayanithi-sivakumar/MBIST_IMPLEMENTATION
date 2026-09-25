//==============================================================================
//MSPAND Technologies pvt ltd//
//copyright(c) 2026 MSPAND Technologies pvt ltd
//All rights reserved
//
//
//Project: BIST
//module : Responce Analyser
//Author : Vaideeshwaran V
//Date   : 18/06/26
//Description : Designing Boundary scan register(JTAG)
//
//
//Version :v1.1
//
//revision Updates
//0.1-18/06/26-initial
//
//
//============================================================================//


module resp_analy(
input ra,clk,rst,in,pat_done,
input [1:0]exp_sel,
input [3:0]cut_out,
output reg bist_done,
output reg pass,fail
);

reg [3:0] exp_out;

always @(negedge clk or posedge rst)begin
if(rst)
	exp_out<=4'b0;
else begin
	case(exp_sel)
	2'b00:exp_out={3'b000,in};
	2'b01:exp_out={2'b00,in,1'b0};
	2'b10:exp_out={1'b0,in,2'b00};
	2'b11:exp_out={in,3'b000};
	endcase
end
end

always @(posedge clk or posedge rst)begin
if(rst)begin
	pass<=1'b0;
	fail<=1'b0;
end
else if(exp_out==cut_out && ra)begin
	pass<=1'b1;
	fail<=1'b0;
end
else begin
	if(exp_out!=cut_out && ra)begin
		pass<=1'b0;
		fail<=1'b1;
	end
	else begin
		pass<=1'b0;
		fail<=1'b0;
	end
end
end

always@(posedge clk or posedge rst)begin
if(rst)begin
	bist_done<=1'b0;
end
else begin
	if(pat_done && ra) 
		bist_done<=1'b1;
	else
		bist_done<=1'b0;
end
end

endmodule


/*//testbench

module tb_ra;
reg ra,clk,rst,in,pat_done;
reg [1:0]exp_sel;
reg [3:0]cut_out;
wire bist_done;
wire pass,fail;


resp_analy dut(.ra(ra),.clk(clk),.rst(rst),.exp_sel(exp_sel),.in(in),.pat_done(pat_done),.cut_out(cut_out),.bist_done(bist_done),.pass(pass),.fail(fail));

initial begin
	$dumpfile("ra.vcd");
	$dumpvars(0,tb_ra);
	ra=1'b1;clk=0;rst=1;
	#5 rst=0;exp_sel=2'b01;in=1;cut_out=4'b0010;
	#10 exp_sel=2'b10;cut_out=4'b0100;
	#5 pat_done=1;
#100 $finish;
end

always #5 clk=~clk;

endmodule*/
