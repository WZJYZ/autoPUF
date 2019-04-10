/*
MUX路径选择模块
*/
module MOD_BLOCK
(
  input  IN,
  input  S, //激励或调整信号
  output OUT
);

(* dont_touch = "true" *) LUT6 #(.INIT(8'b11001010)) mux(.I0(IN), .I1(IN), .I2(S), .I3(1'b0), .I4(1'b0), .I5(1'b0), .O(OUT));

endmodule
