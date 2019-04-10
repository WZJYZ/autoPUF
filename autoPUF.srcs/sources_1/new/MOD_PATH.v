/*
路径模块：包括chblock（激励模块）和adjblock（调整模块）
*/
module MOD_PATH
(
  input IN, //跳变
  input [31:0]CH, //激励
  input [31:0]ADJ,//调整信号
  output OUT //输出
);
/*
verilog 的generate的用法：
    生成语句可以动态的生成verilog代码，当对矢量中的多个位进行重
复操作时，或者当进行多个模块的实例引用的重复操作时，或者根据参数
的定义来确定程序中是否应该包含某段Verilog代码的时候，使用生成语
句能大大简化程序的编写过程。
generate语句有generate-for, generate-if和generate-case三种语句
generate-for：
（1) 必须有genvar关键字定义for语句的变量。
（2）for语句的内容必须加begin和end（即使就一句）。
（3）for语句必须有个名字
*/
genvar i;

wire [32:0]chblock_wire;
assign chblock_wire[0]=IN;
generate
for (i=0;i<32;i=i+1)
begin
  (* dont_touch = "true" *) MOD_BLOCK chblock(chblock_wire[i],CH[i],chblock_wire[i+1]);
end
endgenerate

wire [32:0]adjblock_wire;
assign adjblock_wire[0]=chblock_wire[32];
generate
for (i=0;i<32;i=i+1)
begin
  (* dont_touch = "true" *) MOD_BLOCK adjblock(adjblock_wire[i],ADJ[i],adjblock_wire[i+1]);
end
endgenerate
assign OUT=adjblock_wire[32];

endmodule
