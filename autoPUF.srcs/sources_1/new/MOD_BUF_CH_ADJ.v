/*
此模块功能：缓冲？
*/
module MOD_BUF_CH_ADJ(
    input clk,
    input [31:0]ch,
    input [31:0]adj0,
    input [31:0]adj1,
    output reg [31:0]ch_buf,
    output reg [31:0]adj0_buf,
    output reg [31:0]adj1_buf
    );

(* dont_touch = "true" *) always @(posedge clk) ch_buf<=ch;
(* dont_touch = "true" *) always @(posedge clk) adj0_buf<=adj0;
(* dont_touch = "true" *) always @(posedge clk) adj1_buf<=adj1;

endmodule
