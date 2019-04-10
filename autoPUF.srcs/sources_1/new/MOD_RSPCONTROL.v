/*
响应控制模块：由一个D触发器组成
*/
module MOD_RSPCONTROL
(
  input RSP_CAPTURE, //clock port
  input RSP, // D port
  output reg RSP_BUF // Q port
);

always @(posedge RSP_CAPTURE) RSP_BUF<=RSP;

endmodule
