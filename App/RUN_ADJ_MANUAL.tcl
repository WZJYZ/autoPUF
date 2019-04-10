#<
set MANUAL_ADJ0 00000001111111111111110000000000
set MANUAL_ADJ1 00000000000000000000000000000000
set FILE_CRP_M  $FOLDER_CRP/crp/m.crp

set cs_file_adjchseed $FOLDER_CRP/adj/m.chseed
set cs_num_crp 100
#>

source $FOLDER_CODE/FUNC_GENCHSEED.tcl

#循环次数
set rs_repeat 1

set rs_adj0 $MANUAL_ADJ0
set rs_adj1 $MANUAL_ADJ1

#读取种子文件
set finchseed [open $cs_file_adjchseed r]
#从m.chseed中读取第一行：即cs_num_active = 1
gets $finchseed rs_num_active
for {set a 0} {$a<$rs_num_active} {incr a} {
	#从m.chseed中读取第二行：即32位的种子01序列
	#rs_ch_seed是一个包含多个种子的数组
	gets $finchseed rs_ch_seed($a)
}
close $finchseed

source $FOLDER_CODE/FUNC_GETCRP.tcl

puts "$rs_uniform $rs_reliable"

set foutcrp [open $FILE_CRP_M w]
for {set c 0} {$c<$rs_num_crp} {incr c} {
	puts -nonewline $foutcrp $rs_crp_ch($c)
	puts -nonewline $foutcrp " "
	for {set r 0} {$r<$rs_repeat} {incr r} {
		puts -nonewline $foutcrp $rs_crp_rsp($c,$r)
	}
	puts $foutcrp ""
}
close $foutcrp
