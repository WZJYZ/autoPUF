# cd "D:/demo2/autoPUF"

#############################################################
####################### setup ###############################
#############################################################
set FOLDER_CODE    "D:/demo2/autoPUF"

set FOLDER_PROJECT "D:/demo2/autoPUF"
set NAME_PROJECT	 "autoPUF"

set FOLDER_CRP     "D:/demo2/autoPUF/CRP"

set NAME_BOARD     "ZC702"
#Support: ZC702 KC705 zedboard
#
set CHBIT           32
##LFSR哪些位置添加异或
set LFSR_CONFIG    "0010_0011_1010_0100_1000_0001_0110_0011" 

set ADJBIT          32

set PLACE_TRAN_X    101
set PLACE_TRAN_Y    100

set CYCLE_CH        8
set CYCLE_RSP       14
set CYCLE_CAPTURE	  6

#4096个时钟周期
set ILA_SIZE        4096

#############################################################
set FOLDER_SOURCES   "$FOLDER_PROJECT/$NAME_PROJECT.srcs/sources_1"
set FOLDER_CONSTRS   "$FOLDER_PROJECT/$NAME_PROJECT.srcs/constrs_1"
set FILE_BIT         "$FOLDER_PROJECT/$NAME_PROJECT.runs/impl_1/MOD_HW.bit"
set FILE_LTX         "$FOLDER_PROJECT/$NAME_PROJECT.runs/impl_1/debug_nets.ltx"

##0-31
set CHPORT  [expr $CHBIT-1]
set ADJPORT [expr $ADJBIT-1]

set PLACE_X1 $PLACE_TRAN_X
set PLACE_X0 [expr $PLACE_X1-4]
#CYCLE_TOTAL:30
set CYCLE_TOTAL	  [expr $CYCLE_CH+$CYCLE_RSP+$CYCLE_CAPTURE+2]
set CHCONTROLPORT [expr int(ceil (log($CYCLE_TOTAL)/log(2)))-1]

set NAME_PART     "null"
set NAME_DEVICE	  "null"
set IS_DIFFPOWER   -1
set PACKAGE_PIN_N "null"
set IOSTANDARD_N  "null"
set PACKAGE_PIN_P "null"
set IOSTANDARD_P  "null"
set BEL_TRAN      "null"
set BEL_CH        "null"
set PIN_CH        "null"
set BEL_ADJ       "null"
set PIN_ADJ       "null"
set BEL_ARB       "null"
set PBLOCK_CONTR  "null"
if       {$NAME_BOARD=="ZC702"||$NAME_BOARD=="zc702"} {
	set NAME_PART     "xc7z020clg484-1"
	set NAME_DEVICE	  "xc7z020_1"
	set IS_DIFFPOWER   1
	set PACKAGE_PIN_N	"C19"
	set IOSTANDARD_N	"LVDS_25"
	set PACKAGE_PIN_P	"D18"
	set IOSTANDARD_P	"LVDS_25"
  set BEL_TRAN      "C6LUT"
  set BEL_CH        "D6LUT"
  set PIN_CH        "\{I0:A5 I1:A6 I2:A1\}"
  set BEL_ADJ       "D6LUT"
  set PIN_ADJ       "\{I0:A5 I1:A6 I2:A1\}"
  set BEL_ARB       "DFF"
  set PBLOCK_CONTR  "{CLOCKREGION_X0Y0:CLOCKREGION_X0Y0}"
} elseif {$NAME_BOARD=="KC705" || $NAME_BOARD=="kc705"} {
	set NAME_PART     "xc7k325tffg900-2"
	set NAME_DEVICE	  "xc7k325t_0"
	set IS_DIFFPOWER   1
	set PACKAGE_PIN_N	"AD11"
	set IOSTANDARD_N	"LVDS"
	set PACKAGE_PIN_P	"AD12"
	set IOSTANDARD_P	"LVDS"
  set BEL_TRAN      "C6LUT"
  set BEL_CH        "D6LUT"
  set PIN_CH        "\{I0:A5 I1:A6 I2:A1\}"
  set BEL_ADJ       "D6LUT"
  set PIN_ADJ       "\{I0:A5 I1:A6 I2:A1\}"
  set BEL_ARB       "DFF"
  set PBLOCK_CONTR  "{CLOCKREGION_X0Y0:CLOCKREGION_X0Y0}"
} elseif {$NAME_BOARD=="Zedboard"||$NAME_BOARD=="ZedBoard"||$NAME_BOARD=="zedboard"} {
	set NAME_PART     "xc7z020clg484-1"
	set NAME_DEVICE	  "xc7z020_1"
	set IS_DIFFPOWER   0
	set PACKAGE_PIN_N "Y9"
	set IOSTANDARD_N  "LVCMOS33"
  set BEL_TRAN      "C6LUT"
  set BEL_CH        "D6LUT"
  set PIN_CH        "\{I0:A5 I1:A6 I2:A1\}"
  set BEL_ADJ       "D6LUT"
  set PIN_ADJ       "\{I0:A5 I1:A6 I2:A1\}"
  set BEL_ARB       "DFF"
  set PBLOCK_CONTR  "{CLOCKREGION_X0Y0:CLOCKREGION_X0Y0}"
}

###########################################################
####################### proc ##############################
###########################################################
proc RANDBINARY {len} {
  set chars [split {01} ""]
  set pw ""
  while {[string length $pw] < $len} {
    set rand [expr int(2*rand())]
    append pw [lindex $chars $rand]
  }
  return $pw
}
