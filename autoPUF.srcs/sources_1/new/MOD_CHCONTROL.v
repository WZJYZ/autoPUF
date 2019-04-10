module MOD_CHCONTROL
(
  input CLK,
  input RST,
  input START,
  output reg CH_GEN,
  output reg TRANSITION,
  output reg RSP_CAPTURE
);

reg enable;
wire control_clk;
reg [4:0] control;
always @(posedge RST or posedge START or posedge CLK)
begin
  if      (RST==1)          enable<=0;
  else if (START==1)        enable<=1;
end
assign control_clk= CLK & enable;

always @(posedge RST or posedge control_clk)
begin
  if      (RST==1)                 control<=0;
  else if (control<30-1) control<=control+1;
  else                             control<=1;
end
always @(posedge RST or posedge CLK)
begin
  if      (RST==1)     CH_GEN<=0;
  else if (control==1) CH_GEN<=1;
  else                 CH_GEN<=0;
end
always @(posedge RST or posedge CLK)
begin
  if      (RST==1)                                              TRANSITION<=0;
  else if (1+8<=control&&control<=8+14) TRANSITION<=1;
  else                                                          TRANSITION<=0;
end
always @(posedge RST or posedge CLK)
begin
  if      (RST==1)                          RSP_CAPTURE<=0;
  else if (control==1+8+14) RSP_CAPTURE<=1;
  else                                      RSP_CAPTURE<=0;
end

endmodule
