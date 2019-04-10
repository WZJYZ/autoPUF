/*
自调整PUF的实现
*/
module MOD_APUF
(
  input IN, //输入信号，用于产生跳变
  input [31:0]CH, //激励
  input [31:0]ADJ0, //调整信号0
  input [31:0]ADJ1, //调整信号1
  output RSP //产生响应比特
);

(* dont_touch = "true" *) wire transition_wire,path0_out,path1_out;
(* dont_touch = "true" *) LUT6 #(.INIT(2'b10)) transition(.I0(IN), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(1'b0), .I5(1'b0), .O(transition_wire));
(* dont_touch = "true" *) MOD_PATH path0(transition_wire,CH,ADJ0,path0_out);
(* dont_touch = "true" *) MOD_PATH path1(transition_wire,CH,ADJ1,path1_out);
(* dont_touch = "true" *) MOD_ARBITER arbiter(path0_out,path1_out,RSP);

endmodule
