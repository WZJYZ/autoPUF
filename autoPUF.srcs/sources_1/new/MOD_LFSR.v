/*
激励产生模块
*/
module MOD_LFSR
(
  input RST,
  input GEN,
  input [31:0]SEED,
  output reg [31:0]OUT
);

always @(posedge RST or posedge GEN)
begin
  if      (RST==1) OUT<=SEED;
  else if (GEN==1)
  begin
    OUT[31] <= OUT[0];
    OUT[30] <= OUT[31];
    OUT[29] <= OUT[30]^OUT[0];
    OUT[28] <= OUT[29];
    OUT[27] <= OUT[28];
    OUT[26] <= OUT[27];
    OUT[25] <= OUT[26]^OUT[0];
    OUT[24] <= OUT[25]^OUT[0];
    OUT[23] <= OUT[24]^OUT[0];
    OUT[22] <= OUT[23];
    OUT[21] <= OUT[22]^OUT[0];
    OUT[20] <= OUT[21];
    OUT[19] <= OUT[20];
    OUT[18] <= OUT[19]^OUT[0];
    OUT[17] <= OUT[18];
    OUT[16] <= OUT[17];
    OUT[15] <= OUT[16]^OUT[0];
    OUT[14] <= OUT[15];
    OUT[13] <= OUT[14];
    OUT[12] <= OUT[13];
    OUT[11] <= OUT[12];
    OUT[10] <= OUT[11];
    OUT[9] <= OUT[10];
    OUT[8] <= OUT[9]^OUT[0];
    OUT[7] <= OUT[8];
    OUT[6] <= OUT[7]^OUT[0];
    OUT[5] <= OUT[6]^OUT[0];
    OUT[4] <= OUT[5];
    OUT[3] <= OUT[4];
    OUT[2] <= OUT[3];
    OUT[1] <= OUT[2]^OUT[0];
    OUT[0] <= OUT[1]^OUT[0];
  end
end

endmodule
