module MOD_ARBITER
(
  input  IN0,
  input  IN1,
  output OUT
);
//FDCE是一个D触发器，根据跳变到达D和C端的快慢产生响应比特0或1
(* dont_touch = "true" *) FDCE #(.INIT(1'b0)) inst_RSP(.CE(1'b1), .CLR(1'b0), .C(IN1), .D(IN0), .Q(OUT));

endmodule
