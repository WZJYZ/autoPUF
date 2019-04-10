module MOD_HW
(
  input CLK_P,
  input CLK_N
);
//(* dont_touch="true" *) 
(* dont_touch="true" *) wire clk;

// Differential Signaling Input Buffer:差分信号缓冲器
IBUFDS #
(
  .DIFF_TERM("FALSE"),
  .IBUF_LOW_PWR("FALSE")
)
inst_ibufds
(
  .O(clk),
  .I(CLK_P),
  .IB(CLK_N)
);

(* dont_touch="true" *) wire rst;
(* dont_touch="true" *) wire start;
(* dont_touch="true" *) wire ch_gen;
(* dont_touch="true" *) wire transition;
(* dont_touch="true" *) wire rsp_capture;
(* dont_touch="true" *) wire [31:0]ch_seed;
(* dont_touch="true" *) wire [31:0]ch;
(* dont_touch="true" *) wire [31:0]ch_buf;
(* dont_touch="true" *) wire [31:0]adj0;
(* dont_touch="true" *) wire [31:0]adj0_buf;
(* dont_touch="true" *) wire [31:0]adj1;
(* dont_touch="true" *) wire [31:0]adj1_buf;
(* dont_touch="true" *) wire rsp;
(* dont_touch="true" *) wire rsp_buf;

(* dont_touch = "true" *) MOD_BUF_CH_ADJ buf_ch_adj(clk,ch,adj0,adj1,ch_buf,adj0_buf,adj1_buf);
(* dont_touch = "true" *) MOD_CHCONTROL chcontrol(clk,rst,start,ch_gen,transition,rsp_capture);
(* dont_touch = "true" *) MOD_LFSR lfsr(rst,ch_gen,ch_seed,ch);
(* dont_touch = "true" *) MOD_APUF apuf(transition,ch_buf,adj0_buf,adj1_buf,rsp);
(* dont_touch = "true" *) MOD_RSPCONTROL rspcontrol(rsp_capture,rsp,rsp_buf);

/*
VIO:Virtual Input Output,即虚拟IO。
VIO的输出可以控制模块的输入， VIO的输入可以显示模块的输出值。
*/

vio inst_vio
(
  .clk(clk),
  .probe_in0(rsp_buf),
  .probe_out0(rst),
  .probe_out1(start),
  .probe_out2(adj0),
  .probe_out3(adj1),
  .probe_out4(ch_seed)
);
/*
ILA是Vivado 的一个DEBUG-IP，通过在RTL中嵌入ILA核，
可以抓取信号的实时波形，帮助我们定位问题。
*/
ila inst_ila(
	.clk(clk),
	.probe0(ch),
	.probe1(rsp_buf),
	.probe2(start)
);

endmodule
