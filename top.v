//==============================================================================
//MSPAND Technologies pvt ltd//
//copyright(c) 2026 MSPAND Technologies pvt ltd
//All rights reserved
//
//
//Project: BIST
//module : TOP
//Author : Vaideeshwaran V
//Date   : 18/06/26
//Description : Designing Top module(BIST)
//
//
//Version :v1.1
//
//revision Updates
//0.1-18/06/26-initial
//
//
//============================================================================//


`include "res_anal.v"
`include "bist_contr.v"
`include "demux1x4.v"
`include "LFSR.v"
`include "tb_top.v"

module top(
input str_bist,clk,rst,
output bist_done,pass,fail,
output [3:0] shift
);

wire pat,ra,pattern,pat_done_w,pass_w,fail_w;
wire [1:0]sel;
wire [3:0]cut_out;

bist_contr DUT1(.str_bist(str_bist),.clk(clk),.rst(rst),.bist_done(bist_done),.pass(pass),.fail(fail),.pat(pat),.ra(ra),.bist_done_w(bist_done_w),.pass_w(pass_w),.fail_w(fail_w));


lfsr DUT2(.clk(clk),.rst(rst),.pat(pat),.pattern(pattern),.pat_done(pat_done),.shift(shift));

assign sel[0]=shift[1];
assign sel[1]=shift[2];

demux1x4 DUT3(.i(pattern),.s0(sel[0]),.s1(sel[1]),.y0(cut_out[0]),.y1(cut_out[1]),.y2(cut_out[2]),.y3(cut_out[3]));

resp_analy DUT4(.ra(ra),.clk(clk),.rst(rst),.in(pattern),.pat_done(pat_done),.exp_sel(sel),.cut_out(cut_out),.bist_done(bist_done_w),.pass(pass_w),.fail(fail_w));

endmodule


